extends ColorRect

@export var flash_duration : float = 0.6

func _ready() -> void:
	SignalBus.RocketExploded.connect(_on_rocket_exploded)

func _on_rocket_exploded(_position: Vector2, color: Color) -> void:
	var mat := material as ShaderMaterial
	mat.set_shader_parameter("edge_color", color)
	var tween := create_tween()
	tween.tween_method(_set_strength.bind(mat), 1.0, 0.0, flash_duration).set_ease(Tween.EASE_OUT)

func _set_strength(value: float, mat: ShaderMaterial) -> void:
	mat.set_shader_parameter("strength", value)
