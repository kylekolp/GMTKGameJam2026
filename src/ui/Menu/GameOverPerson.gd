extends Sprite2D

var timerToWait : float = 0.0

var tween : Tween
var originalPosition : Vector2

func _ready() -> void:
	var randomTime : float = randf_range(2,30)
	timerToWait = randomTime
	originalPosition = position
	
func _process(delta: float) -> void:
	if timerToWait <= 0.0:
		jump()
		var randomTime : float = randf_range(2,6)
		timerToWait = randomTime
	else:
		timerToWait -= delta
		
func jump() -> void:
	if tween and tween.is_running():
			tween.kill()
	
	var randomJumpHeight : float = randf_range(5,15)
	
	tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position:y", originalPosition.y - randomJumpHeight, 1)
	tween.chain().tween_property(self, "position:y", originalPosition.y + 4, .4).set_delay(.2)
	tween.chain().tween_property(self, "position:y", originalPosition.y, .03)
	pass
