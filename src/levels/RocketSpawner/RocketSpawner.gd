extends Node2D

@export var game_start_spawn_interval : float = 2.0
@export var fail_attempts : int = 50
#@export var min_spawn_interval: float = 1.0
#@export var max_spawn_interval: float = 4
var spawn_interval: float = 4
@export var failed_spawn_interval: float = 0.1
@export var min_distance_from_fire: float = 150.0
@export var min_distance_from_rocket: float = 60.0
@export var min_distance_from_rope: float = 40.0
@export var min_distance_from_player: float = 100.0

@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawn_area_top_left: Marker2D = $SpawnAreaTopLeft
@onready var spawn_area_bottom_right: Marker2D = $SpawnAreaBottomRight

var spawn_area: Rect2

var rocketsSpawned : int = 0
var minSpawnInterval : float = 1

func _ready() -> void:
	spawn_area = Rect2(
		spawn_area_top_left.position,
		spawn_area_bottom_right.position - spawn_area_top_left.position
	)
	spawn_timer.start(game_start_spawn_interval)

func _on_spawn_timer_timeout() -> void:
	var howManyRockets : int = howManyRocketsToSpawn(rocketsSpawned)
	spawn_interval = getNextSpawnInterval(rocketsSpawned)
	var countdownTimer : float = getRocketTimer(rocketsSpawned)
	
	var wasSuccessful : bool = false
	
	for i in range(0,howManyRockets):
		var wasSuccess = SpawnRocket(countdownTimer)
		if wasSuccess:
			rocketsSpawned += 1
			wasSuccessful = true
		else:
			for j in range(0,fail_attempts):
				var wasSuccessAfterFail = SpawnRocket(countdownTimer)
				if wasSuccessAfterFail:
					rocketsSpawned += 1
					wasSuccessful = true
					break
	
	print("Rockets Spawned: " + str(rocketsSpawned) + ", HowManyRockets: " + str(howManyRockets) + ", spawnInterval: " + str(spawn_interval) + ", countdownTimer: " + str(countdownTimer))
	
	if wasSuccessful:
		spawn_timer.start(spawn_interval)
	else:
		spawn_timer.start(failed_spawn_interval)

func SpawnRocket(countdownTimer : float) -> bool:
	var candidate_position := Vector2(
		randf_range(spawn_area.position.x, spawn_area.end.x),
		randf_range(spawn_area.position.y, spawn_area.end.y)
	)

	for group in ["Fire", "Rocket", "Player"]:
		var min_distance: float
		if group == "Fire":
			min_distance = min_distance_from_fire
		if group == "Rocket":
			min_distance = min_distance_from_rocket
		if group == "Player":
			min_distance = min_distance_from_player
		if not _is_far_enough_from_group(candidate_position, group, min_distance):
			return false

	if not _is_far_enough_from_rope(candidate_position, min_distance_from_rope):
		return false

	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Rocket, candidate_position, get_parent() as Node2D, countdownTimer)
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ROCKET_SPAWN)
	return true
	
func getNextSpawnInterval(rocketsSpawned : int) -> float:
	var newInterval : float = 0
	if rocketsSpawned <= 4:
		return 3.5
	elif rocketsSpawned >= 5 and rocketsSpawned < 15:
		return 2.5
	elif rocketsSpawned >= 15 and rocketsSpawned < 60:
		return 2
	else:
		return 1.75
		
func howManyRocketsToSpawn(rocketsSpawned : int) -> float:
	if rocketsSpawned <= 4:
		return 1
	if rocketsSpawned == 5:
		return 2
	elif rocketsSpawned >= 5 and rocketsSpawned < 15:
		return 1
	elif rocketsSpawned == 30:
		return 3
	elif rocketsSpawned >= 15 and rocketsSpawned < 40: #After 20 we spawn 2 rockets at a time
		if rocketsSpawned == 20 or rocketsSpawned == 25 or rocketsSpawned == 30 or rocketsSpawned == 35:
			return 2
		else:
			return 1
	elif rocketsSpawned == 40:
		return 4
	elif rocketsSpawned == 45:
		return 4
	elif rocketsSpawned == 55:
		return 5
	else: #After 40 we spawn 3 rockets at a time
		if rocketsSpawned % 10 == 0:
			return 5
		else:
			return 2
	
func getRocketTimer(rocketsSpawned : int) -> float:
	if rocketsSpawned < 10:
		return 12
	elif rocketsSpawned >= 5 and rocketsSpawned < 30:
		return 14
	elif rocketsSpawned >= 30 and rocketsSpawned < 50:
		return 16
	else: #After 40 we spawn 3 rockets at a time
		return 18

func _is_far_enough_from_group(position: Vector2, group: StringName, min_distance: float) -> bool:
	for node in get_tree().get_nodes_in_group(group):
		if position.distance_to(node.global_position) < min_distance:
				return false
	return true

func _is_far_enough_from_rope(position: Vector2, min_distance: float) -> bool:
	for rope in get_tree().get_nodes_in_group("Rope"):
		var rope_line := rope as Line2D
		if rope_line == null:
			continue
		var pts := rope_line.points
		if pts.size() < 2:
			continue
		for i in range(pts.size() - 1):
				var closest := Geometry2D.get_closest_point_to_segment(position, pts[i], pts[i + 1])
				if position.distance_to(closest) < min_distance:
					return false
	return true
