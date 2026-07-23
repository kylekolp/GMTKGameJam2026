class_name Entity_Rope
extends Line2D

@export var drawingDelayTimer: Timer

@export var fireSpawnTimer : Timer

signal RopeComplete(rope : Entity_Rope)

var is_drawing := false
var target: Node2D

var ropeHealth : int = 50
var activeFires : int = 0

var previousPoint : Vector2 = Vector2.ZERO
var minPointDistance : float = 20

func _ready() -> void:
	top_level = true
	target = get_parent()

func start_drawing() -> void:
	clear_points()
	is_drawing = true

func stop_drawing() -> void:
	RopeComplete.emit(self)
	is_drawing = false
	fireSpawnTimer.start() #Start spawning fire

func _process(delta: float) -> void:
	if is_drawing and drawingDelayTimer.is_stopped():
		
		if previousPoint == Vector2.ZERO or (previousPoint != Vector2.ZERO and previousPoint.distance_to(target.global_position) > minPointDistance):
		
			add_point(target.global_position)
			previousPoint = points[points.size()-1]
			drawingDelayTimer.start(.1)

func _on_fire_spawn_timer_timeout() -> void:
	if ropeHealth == activeFires: #Dont spawn more fire if
		return
	
	var ropeEndPosition : Vector2 = Vector2(points[points.size()-1].x,points[points.size()-1].y)
	var fireBurn : Entity_FireBurnRope = await SpawnFireBurn(ropeEndPosition)
	activeFires += 1
	fireBurn.FireTravelComplete.connect(fireMadeItToRocket)
	
	#var newFire : Entity_FireBurnRope = get_child("")
	
	pass # Replace with function body.

func get_child_of_type(type: GDScript) -> Node:
	for child in get_children():
		if is_instance_of(child, type):
			return child
	return null
	
func SpawnFireBurn(position: Vector2) -> Entity_FireBurnRope: 
	return await SpawnFireBurnAtPosition(UIDCatalog.Entity_FireBurnRope,position,self)
	
func SpawnFireBurnAtPosition(entityUID : String, position: Vector2, parent : Node2D = null) -> Entity_FireBurnRope:
	var entityPackedScene : PackedScene = ResourceLoader.load(entityUID, "PackedScene") as PackedScene
	if entityPackedScene == null:
		push_error("Rope Spawn Fire: Could not load entity as packed scene: " + entityUID)
		return
		
	var newEntity = entityPackedScene.instantiate() as Entity_FireBurnRope
	if newEntity == null:
		push_error("Rope Spawn Fire: Loaded Entity Scene was not able to instantiate " + entityUID)
		return
	
	self.add_child(newEntity)
	
	newEntity.position = position
	
	#Allow the new level to process before accessing it
	await get_tree().process_frame
	
	return newEntity
	
func fireMadeItToRocket(fireEntity : Node2D) -> void:
	activeFires -= 1
	ropeHealth -= 1
	print("RopeHealth: " + str(ropeHealth))
	
	if ropeHealth == 0:
		queue_free()
		
func BurnRope() -> void:
	queue_free()
