class_name Player
extends CharacterBody2D

@export var movement_speed : float

@onready var rope: Line2D = $Rope

var entityRoot : Node2D

func _ready() -> void:
	SignalBus.RopeComplete.connect(DropRopeOnComplete)
	entityRoot = get_parent()
	return
	
func _physics_process(delta: float) -> void:
	var direction:= Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
	
	velocity = direction * movement_speed
	
	move_and_slide()

func start_drawing() -> void:
	rope.start_drawing()
	
# Used to drop rope into level
func DropRopeOnComplete(rope : Node2D) -> void:
	rope.reparent(entityRoot)
