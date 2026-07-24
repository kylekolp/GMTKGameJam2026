extends BaseMenu

func _on_continue_button_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	SignalBus.StartGame.emit()
	queue_free()
