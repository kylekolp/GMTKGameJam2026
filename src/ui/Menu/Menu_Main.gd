extends BaseMenu

func _on_start_game_button_pressed() -> void:
	SignalBus.StartGame.emit()
	queue_free()

func _on_options_button_pressed() -> void:
	SignalBus.LoadMenu.emit(UIDCatalog.Menu_Options)

func _on_quit_game_button_pressed() -> void:
	SignalBus.TryQuit.emit()
