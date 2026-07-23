extends Node2D

@onready var circle_timer: TextureProgressBar = $CircleTimer

func _ready() -> void:
	circle_timer.value = circle_timer.max_value
	var tween := create_tween()
	tween.tween_property(circle_timer, "value", 0.0, 10.0)
	tween.finished.connect(_on_countdown_finished)

func _on_countdown_finished() -> void:
	SignalBus.GameOver.emit()

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	var bodyGroups : Array[StringName] = body.get_groups()
	
	if "Player" in bodyGroups:
		body.start_drawing()
