class_name Entity_RopeSegment
extends RigidBody2D

@export var player : Player

var _speed : float = 1000

func _physics_process(delta: float) -> void:
	
	var directionVector = global_position.direction_to(player.global_position);
	
	linear_velocity = directionVector * _speed
	
	return
	#var playerPosition =
