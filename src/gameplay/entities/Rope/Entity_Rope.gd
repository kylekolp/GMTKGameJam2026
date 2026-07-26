class_name Entity_Rope
extends Line2D

# this is like ropeHealth var and BurnComplete signal
@export var HITS_TO_LAUNCH := 10
@export var Fire_Spawn_Time : float
@export var Drawing_Delay_Time : float

@export var burnStepTime : float = 0.04

var attachments: Array[Dictionary] = []

@export var drawingDelayTimer: Timer

@export var fireSpawnTimer : Timer

signal RopeComplete(rope : Entity_Rope)
signal RopeEmpty(rope: Entity_Rope)

var is_drawing := false
var target: Node2D

var activeFires : int = 0

var previousPoint : Vector2 = Vector2.ZERO
var minPointDistance : float = 20

@export var score_per_rocket : int = 10

@export var max_concurrent_embers : int = 10
var burningEmber : Entity_FireBurnRope = null
var is_burning : bool = false

func _ready() -> void:
	top_level = true
	target = get_parent()
	add_to_group("Rope")
	
	fireSpawnTimer.wait_time = Fire_Spawn_Time
	drawingDelayTimer.wait_time = Drawing_Delay_Time

func start_drawing() -> void:
	clear_points()
	is_drawing = true

func stop_drawing(final_point: Vector2 = Vector2.INF) -> void:
	if final_point != Vector2.INF:
		add_point(to_local(final_point))
		previousPoint = points[points.size() - 1]
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ROPE_SCORE)
	RopeComplete.emit(self)
	AddRocketScore()
	is_drawing = false
	fireSpawnTimer.start() #Start spawning fire

func _process(delta: float) -> void:
	if is_drawing and drawingDelayTimer.is_stopped():
		
		if previousPoint == Vector2.ZERO or (previousPoint != Vector2.ZERO and previousPoint.distance_to(target.global_position) > minPointDistance):
		
			add_point(target.global_position)
			previousPoint = points[points.size()-1]
			drawingDelayTimer.start(Drawing_Delay_Time)

func attach_rocket(rocket: Entity_Rocket) -> void:
	add_point(rocket.global_position)
	var attachment = {
		"rocket": rocket,
		"index": points.size() - 1,
		"hits_remaining": HITS_TO_LAUNCH
	}
	attachments.append(attachment)
	rocket.tree_exiting.connect(_on_attached_rocket_exited.bind(attachment))
	var scoreMult = getScoreMult()
	#Attach Multiplier Number here!
	SignalBus.SpawnScoreNumber.emit(scoreMult,"x" + str(scoreMult),rocket.global_position)

func _on_attached_rocket_exited(attachment: Dictionary) -> void:
	attachments.erase(attachment)
	
	if attachments.is_empty():
		if is_drawing:
			RopeEmpty.emit(self)
			queue_free()
		return
	
	if is_drawing:
		_trim_dangling_rope()

func _trim_dangling_rope() -> void:
	var min_index := points.size()
	for a in attachments:
		min_index = min(min_index, a["index"])
	
	if min_index <= 0:
		return
	
	points = points.slice(min_index)
	for a in attachments:
		a["index"] -= min_index

func getScoreMult() -> int:
	if attachments.size() < 5:
		return attachments.size()
	else:
		return 5
		
func AddRocketScore() -> void:
	var scoreMult = getScoreMult()
	var currentMult : int = 1
	
	for item : Dictionary in attachments:
		var rocket : Entity_Rocket = item["rocket"]
		var scoreForRocket : int = currentMult * score_per_rocket
		SignalBus.SpawnScoreNumber.emit(scoreForRocket,str(scoreForRocket),rocket.global_position)
		SignalBus.AddScore.emit(scoreForRocket,self)
		currentMult += 1

func notify_ember_passed_point(index: int, can_finish: bool = true) -> void:
	for attachment in attachments:
		if attachment["index"] == index and attachment["hits_remaining"] > 0:
			if attachment["hits_remaining"] == 1 and not can_finish:
				continue
			attachment["hits_remaining"] -= 1
			attachment["rocket"].bounce_rocket()
			if attachment["hits_remaining"] == 0:
				attachment["rocket"].launch()

func reset_attached_rockets() -> void:
	for attachment in attachments:
		attachment["rocket"].hasRope = false
		attachment["rocket"].shaderMaterial.set_shader_parameter("show_outline",false)

func _on_fire_spawn_timer_timeout() -> void:
	if total_hits_remaining() == 0 or activeFires >= min(total_hits_remaining(), max_concurrent_embers):
		return
	if is_burning and (burningEmber == null or not burningEmber.is_paused):
		return

	var target_burn_index := NO_BURN
	if not is_burning:
		target_burn_index = get_burn_target_index()
		if target_burn_index != NO_BURN:
			is_burning = true

	activeFires += 1
	var fireBurn : Entity_FireBurnRope = await SpawnFireBurn(points[points.size() - 1])
	fireBurn.burnDownToIndex = target_burn_index
	if target_burn_index != NO_BURN:
		burningEmber = fireBurn
	fireBurn.FireTravelComplete.connect(_on_fire_travel_complete)

func _on_fire_travel_complete(fireEntity : Node2D) -> void:
	activeFires -= 1
	if fireEntity == burningEmber:
		is_burning = false
		burningEmber = null
	if total_hits_remaining() == 0:
		queue_free()

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
	
func BurnRope() -> void:
	is_drawing = false

	var dead_tween := create_tween()
	var color_duration : float = min(points.size() * burnStepTime, 0.25) # burn color max duration
	dead_tween.tween_property(self, "modulate", Color.BLACK, color_duration)
	
	var burn_tween := create_tween()
	for i in range(points.size() - 1, -1, -1):
		burn_tween.tween_callback(burn_to.bind(i))
		burn_tween.tween_interval(burnStepTime)
	burn_tween.finished.connect(queue_free)

const NO_BURN := -2

func get_burn_target_index() -> int:
	var safe_boundary := -1 # -1 means safe to burn all the way to index 0
	var any_finishing := false
	for a in attachments:
		if a["hits_remaining"] == 1:
			any_finishing = true
		elif a["hits_remaining"] > 1:
			safe_boundary = max(safe_boundary, a["index"])
	return safe_boundary if any_finishing else NO_BURN

func burn_to(index: int) -> void:
	if index >= points.size() - 1:
		return
	points = points.slice(0, index + 1)
