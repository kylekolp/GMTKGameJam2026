extends System
#Handles the user Pausing and UnPausing the game

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("PauseGame"):
		if get_tree().paused:
			SignalBus.UnPause.emit()
			Music.get_stream_playback().switch_to_clip_by_name("Game")
		else:
			SignalBus.Pause.emit()
