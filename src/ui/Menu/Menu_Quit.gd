extends BaseMenu_Popup

#Quit the game
func _on_yes_button_pressed() -> void:
	SignalBus.ConfirmQuit.emit()

#Close the menu
func _on_no_button_pressed() -> void:
	queue_free()
