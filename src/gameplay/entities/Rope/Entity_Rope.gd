class_name Entity_Rope
extends Line2D

# this is like ropeHealth var and BurnComplete signal
const HITS_TO_LAUNCH := 10

var attachments: Array[Dictionary] = []
var ignitedRopes : Array[Entity_Rope] = []

@export var drawingDelayTimer: Timer

@export var fireSpawnTimer : Timer

signal RopeComplete(rope : Entity_Rope)

var is_drawing := false
var target: Node2D

var activeFires : int = 0

var previousPoint : Vector2 = Vector2.ZERO
var minPointDistance : float = 20

func _ready() -> void:
	top_level = true
	target = get_parent()
	add_to_group("Rope")

func start_drawing() -> void:
	clear_points()
	is_drawing = true

func stop_drawing() -> void:
	RopeComplete.emit(self)
	is_drawing = false
	fireSpawnTimer.start() #Start spawning fire

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	if is_drawing and drawingDelayTimer.is_stopped():
		
		if previousPoint == Vector2.ZERO or (previousPoint != Vector2.ZERO and previousPoint.distance_to(target.global_position) > minPointDistance):
		
			add_point(target.global_position)
			previousPoint = points[points.size()-1]
			drawingDelayTimer.start(.1)

func attach_rocket(rocket: Entity_Rocket) -> void:
	add_point(rocket.global_position)
	attachments.append({
		"rocket": rocket,
		"index": points.size() - 1,
		"hits_remaining": HITS_TO_LAUNCH
	})

func notify_ember_passed_point(index: int) -> void:
	for attachment in attachments:
		if attachment["index"] == index and attachment["hits_remaining"] > 0:
			attachment["hits_remaining"] -= 1
			if attachment["hits_remaining"] == 0:
				attachment["rocket"].launch()
	
	if total_hits_remaining() == 0:
		queue_free()

func reset_attached_rockets() -> void:
	for attachment in attachments:
		attachment["rocket"].hasRope = false

func _on_fire_spawn_timer_timeout() -> void:
	if total_hits_remaining() == 0 or activeFires >= total_hits_remaining():
		return
	
	var fireBurn : Entity_FireBurnRope = await SpawnFireBurn(points.size() - 1)
	activeFires += 1
	fireBurn.FireTravelComplete.connect(_on_fire_travel_complete)

@warning_ignore("unused_parameter")
func _on_fire_travel_complete(fireEntity : Node2D) -> void:
	activeFires -= 1

func total_hits_remaining() -> int:
	var total := 0
	for attachment in attachments:
		total += attachment["hits_remaining"]
	return total

func get_child_of_type(type: GDScript) -> Node:
	for child in get_children():
		if is_instance_of(child, type):
			return child
	return null
	
func SpawnFireBurn(index: int) -> Entity_FireBurnRope: 
	return await SpawnFireBurnAtIndex(UIDCatalog.Entity_FireBurnRope, index, self)
	
@warning_ignore("unused_parameter")
func SpawnFireBurnAtIndex(entityUID : String, index: int, parent : Node2D = null) -> Entity_FireBurnRope:
	var entityPackedScene : PackedScene = ResourceLoader.load(entityUID, "PackedScene") as PackedScene
	if entityPackedScene == null:
		push_error("Rope Spawn Fire: Could not load entity as packed scene: " + entityUID)
		return
		
	var newEntity = entityPackedScene.instantiate() as Entity_FireBurnRope
	if newEntity == null:
		push_error("Rope Spawn Fire: Loaded Entity Scene was not able to instantiate " + entityUID)
		return
	
	newEntity.startIndex = index
	self.add_child(newEntity)
	newEntity.position = points[index]
	
	#Allow the new level to process before accessing it
	await get_tree().process_frame
	
	return newEntity

func ignite_from_point(from_rope: Entity_Rope, index: int) -> void:
	if from_rope in ignitedRopes:
		return
	if total_hits_remaining() == 0 or activeFires >= total_hits_remaining():
		return
	ignitedRopes.append(from_rope)
	from_rope.ignitedRopes.append(self)
	
	for attachment in attachments:
		attachment["rocket"].stop_countdown()
	
	var fireBurn : Entity_FireBurnRope = await SpawnFireBurn(index)
	activeFires += 1
	fireBurn.FireTravelComplete.connect(_on_fire_travel_complete)
	
func BurnRope() -> void:
	queue_free()
