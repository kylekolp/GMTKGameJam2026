extends ColorRect

@export var flash_duration : float = 0.6

func _ready() -> void:
	SignalBus.RocketExploded.connect(_on_rocket_exploded)

func _on_rocket_exploded(rocket_position: Vector2, color: Color) -> void:
	var mat := material as ShaderMaterial
	var screen_x := (get_viewport().get_canvas_transform() * rocket_position).x
	var viewport_width := get_viewport_rect().size.x
	mat.set_shader_parameter("center_x", clamp(screen_x / viewport_width, 0.0, 1.0))
	mat.set_shader_parameter("edge_color", color)
	var tween := create_tween()
	tween.tween_method(_set_strength.bind(mat), 0.6, 0.0, flash_duration).set_ease(Tween.EASE_OUT)

func _set_strength(value: float, mat: ShaderMaterial) -> void:
	mat.set_shader_parameter("strength", value)
