extends Control

@export var QuitMenuRoot : Control

#Quit the game
func _on_yes_button_pressed() -> void:
	SignalBus.QuitGame.emit()

#Close the menu
func _on_no_button_pressed() -> void:
	QuitMenuRoot.queue_free()
