extends Control


func _on_restart_button_pressed() -> void:
	SignalBus.StartGame.emit()
	queue_free()
