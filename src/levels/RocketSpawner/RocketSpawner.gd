extends Node2D

@export var spawn_interval: float = 2.0
@export var failed_spawn_interval: float = 0.1
@export var min_distance_from_fire: float = 150.0
@export var min_distance_from_rocket: float = 60.0
@export var min_distance_from_rope: float = 40.0
@export var min_distance_from_player: float = 100.0

@onready var spawn_timer: Timer = $SpawnTimer
@onready var spawn_area_top_left: Marker2D = $SpawnAreaTopLeft
@onready var spawn_area_bottom_right: Marker2D = $SpawnAreaBottomRight

var spawn_area: Rect2

func _ready() -> void:
	spawn_area = Rect2(
		spawn_area_top_left.position,
		spawn_area_bottom_right.position - spawn_area_top_left.position
	)
	spawn_timer.start(spawn_interval)

func _on_spawn_timer_timeout() -> void:
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
			spawn_timer.start(failed_spawn_interval)
			return

	if not _is_far_enough_from_rope(candidate_position, min_distance_from_rope):
		spawn_timer.start(failed_spawn_interval)
		return

	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Rocket, candidate_position, get_parent() as Node2D)
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ROCKET_SPAWN)
	spawn_timer.start(spawn_interval)

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
