class_name Entity_Rocket
extends Node2D

@onready var circle_timer: TextureProgressBar = $CircleTimer

@export var countdownTime : float = 60.0 # debug

var countdown_tween : Tween
var hasRope : bool = false
var timer_stopped : bool = false

var rope : Entity_Rope

func _ready() -> void:
	circle_timer.value = circle_timer.max_value
	countdown_tween = create_tween()
	countdown_tween.tween_property(circle_timer, "value", 0.0, countdownTime)
	countdown_tween.finished.connect(_on_countdown_finished)

func _on_countdown_finished() -> void:
	SignalBus.GameOver.emit()

func stop_countdown() -> void:
	if timer_stopped:
		return
	timer_stopped = true
	countdown_tween.kill()
	circle_timer.queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	var bodyGroups : Array[StringName] = body.get_groups()
	
	if "Player" not in bodyGroups or hasRope:
		return
	
	if not body.hasRope():
		hasRope = true
		rope = body.start_drawing(self)
	elif body.currentRope.is_drawing:
		hasRope = true
		rope = body.attach_rocket_to_current_rope(self)
	else:
		return
	
	rope.RopeComplete.connect(_on_rope_complete)

func _on_rope_complete(rope : Node2D) -> void:
	rope.RopeComplete.disconnect(_on_rope_complete)
	stop_countdown()

func launch() -> void:
	#Play firework launch animation
	queue_free()
