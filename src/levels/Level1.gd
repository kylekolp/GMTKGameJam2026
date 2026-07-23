extends Level

@export var rocket_spawn_interval: float = 2.0
@export var failed_rocket_spawn_interval: float = 0.1

@onready var rocket_spawn_timer: Timer = $RocketSpawnTimer
@onready var rocket_spawn_area_top_left: Marker2D = $SpawnAreaTopLeft
@onready var rocket_spawn_area_bottom_right: Marker2D = $SpawnAreaBottomRight

var rocket_spawn_area: Rect2
@export var min_distance_from_fire: float = 150.0
@export var min_distance_from_rocket: float = 80.0

func _ready() -> void:
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Player, Vector2(100,100), self)
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Fire, Vector2(100,600), self)
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Fire, Vector2(1000,600), self)
	
	rocket_spawn_area = Rect2(
		rocket_spawn_area_top_left.position,
		rocket_spawn_area_bottom_right.position - rocket_spawn_area_top_left.position
	)
	
	rocket_spawn_timer.start(rocket_spawn_interval)

func _on_rocket_spawn_timer_timeout() -> void:
	var candidate_position := Vector2(
		randf_range(rocket_spawn_area.position.x, rocket_spawn_area.end.x),
		randf_range(rocket_spawn_area.position.y, rocket_spawn_area.end.y)
	)
	
	for group in ["Fire", "Rocket"]:
		if not _is_far_enough_from_group(candidate_position, group, min_distance_from_fire):
			rocket_spawn_timer.start(failed_rocket_spawn_interval)
			return
	
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Rocket, candidate_position, self)
	rocket_spawn_timer.start(rocket_spawn_interval)

func _is_far_enough_from_group(position: Vector2, group: StringName, min_distance: float) -> bool:
	for node in get_tree().get_nodes_in_group(group):
		if position.distance_to(node.global_position) < min_distance:
			return false
	return true
