extends Control

func _on_start_game_button_pressed() -> void:
	#To Do: Create Options Menu
	#SignalBus.emit_signal("LoadLevel","Level1UID")
	return

func _on_options_button_pressed() -> void:
	#To Do: Create Settings Menu
	#SignalBus.emit_signal("LoadMenu","SettingsUID")
	return

func _on_quit_game_button_pressed() -> void:
	SignalBus.emit_signal("LoadMenu","uid://tl3m7s666fu6")
