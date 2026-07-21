extends BaseMenu

func _on_start_game_button_pressed() -> void:
	#To Do: Create Start Level
	#SignalBus.emit_signal("LoadLevel","Level1UID")
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	return

func _on_options_button_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	SignalBus.LoadMenu.emit(UIDCatalog.Menu_Options)

func _on_quit_game_button_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	SignalBus.TryQuit.emit()
