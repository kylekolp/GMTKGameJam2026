extends BaseMenu

@export var numberSpawner : Particle_DamageNumber

func _on_start_game_button_pressed() -> void:
	#To Do: Create Start Level
	#SignalBus.emit_signal("LoadLevel","Level1UID")
	return

func _on_options_button_pressed() -> void:
	SignalBus.LoadMenu.emit(UIDCatalog.Menu_Options)

func _on_quit_game_button_pressed() -> void:
	SignalBus.TryQuit.emit()
