extends Node2D


func _on_area_2d_body_entered(body: Node2D) -> void:
	var bodyGroups: Array[StringName] = body.get_groups()
	
	if "Player" in bodyGroups and body.rope.is_drawing:
		body.rope.stop_drawing()
