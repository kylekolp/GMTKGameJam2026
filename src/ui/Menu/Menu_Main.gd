extends BaseMenu

func _on_start_game_button_pressed() -> void:
	SignalBus.StartGame.emit()
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	queue_free()

func _on_options_button_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	SignalBus.LoadMenu.emit(UIDCatalog.Menu_Options)

func _on_quit_game_button_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	SignalBus.TryQuit.emit()
