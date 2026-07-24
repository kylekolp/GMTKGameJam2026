class_name Menu_GameOver
extends Control

var score : String

func SetScore() -> void:
	var scoreLabel : Label = $ScoreLabel
	scoreLabel.text = "Final Score: " + score

func _on_restart_button_pressed() -> void:
	SignalBus.StartGame.emit()
	queue_free()


func _on_main_menu_button_pressed() -> void:
	SignalBus.UnloadLevel.emit()
	SignalBus.UnPause.emit()
	SignalBus.LoadMenu.emit(UIDCatalog.Menu_Main)
	queue_free()
