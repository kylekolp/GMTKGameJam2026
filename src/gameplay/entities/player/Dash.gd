class_name Dash
extends Node2D

@onready var cooldownTimer : Timer = $CooldownTimer

func start_dash(duration) -> void:
	cooldownTimer.wait_time = duration
	cooldownTimer.start()
	
func is_dashing() -> bool:
	return !cooldownTimer.is_stopped()
