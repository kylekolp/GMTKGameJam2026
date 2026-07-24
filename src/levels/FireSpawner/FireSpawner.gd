extends Node2D

@export var min_distance_between_fires: float = 300.0
@export var max_placement_attempts: int = 30

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
	var candidate := Vector2.ZERO
	for attempt in range(max_placement_attempts):
		candidate = Vector2(
			randf_range(fire_area.position.x, fire_area.end.x),
			randf_range(fire_area.position.y, fire_area.end.y)
		)
		var far_enough := true
		for other in existing:
			if candidate.distance_to(other) < min_distance_between_fires:
				far_enough = false
				break
		if far_enough:
			return candidate
	return candidate
