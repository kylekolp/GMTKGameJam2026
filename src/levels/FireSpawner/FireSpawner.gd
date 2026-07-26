extends Node2D

@export var min_distance_between_fires: float = 900.0
@export var max_placement_attempts: int = 20

@onready var fire_area_top_left: Marker2D = $FireAreaTopLeft
@onready var fire_area_bottom_right: Marker2D = $FireAreaBottomRight

var fire_area: Rect2

func _ready() -> void:
	fire_area = Rect2(
		fire_area_top_left.position,
		fire_area_bottom_right.position - fire_area_top_left.position
	)
	
	var placed_positions: Array[Vector2] = []
	for i in range(2):
		var position := _pick_position(placed_positions)
		placed_positions.append(position)
		SignalBus.LoadEntity.emit(UIDCatalog.Entity_Fire, position, get_parent() as Node2D)


func _pick_position(existing: Array[Vector2]) -> Vector2:
	if existing.is_empty():
		return _random_point()
	
	var best_candidate := _random_point()
	var best_distance := _min_distance_to(best_candidate, existing)
	for i in range(max_placement_attempts):
		if best_distance >= min_distance_between_fires:
			break
		var candidate := _random_point()
		var distance := _min_distance_to(candidate, existing)
		if distance > best_distance:
			best_candidate = candidate
			best_distance = distance
	return best_candidate

func _random_point() -> Vector2:
	return Vector2(
			randf_range(fire_area.position.x, fire_area.end.x),
			randf_range(fire_area.position.y, fire_area.end.y)
		)

func _min_distance_to(point: Vector2, existing: Array[Vector2]) -> float:
	var closest := INF
	for other in existing:
		closest = min(closest, point.distance_to(other))
	return closest
