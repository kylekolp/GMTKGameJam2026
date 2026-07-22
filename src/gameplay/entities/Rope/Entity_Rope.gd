extends Line2D

var is_drawing := false
var target: Node2D

func _ready() -> void:
	top_level = true
	target = get_parent()

func start_drawing() -> void:
	clear_points()
	is_drawing = true

func stop_drawing() -> void:
	is_drawing = false

func _process(delta: float) -> void:
	if is_drawing:
		add_point(target.global_position)
