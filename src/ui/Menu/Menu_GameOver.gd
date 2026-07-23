extends Control


func _on_restart_button_pressed() -> void:
	SignalBus.LoadLevel.emit(UIDCatalog.Level_1)
	queue_free()
