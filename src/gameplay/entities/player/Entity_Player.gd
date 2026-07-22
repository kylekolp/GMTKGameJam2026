class_name Player
extends CharacterBody2D

@export var movement_speed : float

func _ready() -> void:
	return
	
func _physics_process(delta: float) -> void:
	var direction:= Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
	
	velocity = direction * movement_speed
	
	move_and_slide()
