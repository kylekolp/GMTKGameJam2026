extends Node2D

@onready var circle_timer: TextureProgressBar = $CircleTimer

var countdownTime : float = 60.0

var countdown_tween : Tween
var hasRope : bool = false

var rope : Entity_Rope

func _ready() -> void:
	circle_timer.value = circle_timer.max_value
	countdown_tween = create_tween()
	countdown_tween.tween_property(circle_timer, "value", 0.0, countdownTime)
	countdown_tween.finished.connect(_on_countdown_finished)

func _on_countdown_finished() -> void:
	SignalBus.GameOver.emit()

func _on_area_2d_body_entered(body: Node2D) -> void:
	var bodyGroups : Array[StringName] = body.get_groups()
	
	if "Player" in bodyGroups and !hasRope and !body.hasRope():
		hasRope = true
		rope = body.start_drawing()
		rope.RopeComplete.connect(_on_rope_complete)

# TODO: once we add more than one rope, this will need to check
# that a rope belongs to a rocket before killing its timer
func _on_rope_complete(rope : Node2D) -> void:
	rope.RopeComplete.disconnect(_on_rope_complete)
	countdown_tween.kill()
	circle_timer.queue_free()
