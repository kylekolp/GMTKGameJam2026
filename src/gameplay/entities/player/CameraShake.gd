extends Camera2D

@export var shake_per_explosion : float = 0.6
@export var decay : float = 1.5
@export var max_offset : float = 10.0
@export var max_rotation_degrees : float = 1.5
	
var shake_factor : float = 0.0

func _ready() -> void:
	SignalBus.RocketExploded.connect(_on_rocket_exploded)

func _on_rocket_exploded(_position: Vector2, _color: Color) -> void:
	shake_factor = minf(shake_factor + shake_per_explosion, 1.0)

func _process(delta: float) -> void:
	if shake_factor <= 0.0:
		return
	
	shake_factor = maxf(shake_factor - decay * delta, 0.0)
	var screen_shake := shake_factor * shake_factor
	offset = Vector2(randf_range(-1, 1.0), randf_range(-1, 1.0)) * max_offset * screen_shake
	rotation_degrees = randf_range(-1, 1.0) * max_rotation_degrees * screen_shake
