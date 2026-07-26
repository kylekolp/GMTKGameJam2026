class_name Life
extends TextureRect

@export var lifeError : Sprite2D

func animateHit() -> void:
	lifeError.visible = true
	
	var newScale = Vector2(offset_transform_scale.x + 1.25, offset_transform_scale.y + 1.25)
	var damageColor : Color = Color.from_hsv(0.024, 0.883, 0.502, 1.0)
	
	var tween : Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "offset_transform_scale", newScale, 0.25)
	tween.parallel().tween_property(self, "modulate", damageColor, 0.25)
	tween.chain().tween_property(self, "modulate:a", 0.0, .4).set_delay(.2).finished.connect(queue_free)
