extends Node
#Handles the user Pausing and UnPausing the game

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("PauseGame"):
		if get_tree().paused:
			SignalBus.UnPause.emit()
		else:
			SignalBus.Pause.emit()
