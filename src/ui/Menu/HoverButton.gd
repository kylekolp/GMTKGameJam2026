extends Button

@onready var hoverLines : Sprite2D = $HoverLines

func _on_mouse_entered() -> void:
	#hoverLines.visible = true
	pass


func _on_mouse_exited() -> void:
	#hoverLines.visible = false
	pass
