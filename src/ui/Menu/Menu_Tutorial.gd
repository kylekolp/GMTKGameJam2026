extends BaseMenu_Sub

func _on_continue_button_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	if parentMenu == null:
		SignalBus.StartGame.emit()
	queue_free()
