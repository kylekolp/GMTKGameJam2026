extends BaseMenu

func _on_resume_button_pressed() -> void:
	SignalBus.UnPause.emit()
	queue_free()

func _on_options_button_pressed() -> void:
	SignalBus.LoadMenu.emit(UIDCatalog.Menu_Options)


func _on_main_menu_button_pressed() -> void:
	SignalBus.UnloadLevel.emit()
	SignalBus.UnPause.emit()
	SignalBus.LoadMenu.emit(UIDCatalog.Menu_Main)
	queue_free()


func _on_controls_button_pressed() -> void:
	SignalBus.LoadMenu.emit(UIDCatalog.Menu_Tutorial)
