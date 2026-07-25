class_name DashBar
extends TextureProgressBar

var tween: Tween

var initialScale : Vector2

func _ready() -> void:
	initialScale = offset_transform_scale
	pivot_offset = Vector2(0,size.y/2)

func animateFullDash() -> void:
	tint_progress = Color.from_hsv(0.0, 0.0, 1.0, 1.0)
	
	var newScale = Vector2(initialScale.x + .2, initialScale.y + .2)

	if tween and tween.is_running():
		tween.kill()

	tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "offset_transform_scale", newScale, 0.1)
	tween.chain().tween_property(self, "offset_transform_scale", initialScale, 0.1)

func animateUsedDash() -> void:
	tint_progress = Color.from_hsv(0.0, 0.0, 0.4, 1.0)
	
func GetColorBasedOnValue(value: float) -> Color:
	
	var Color0 : Color = Color.from_hsv(0.0, 0.0, 1.0, 1.0) # Damage 10 - 20
	var Color1: Color = Color.from_hsv(0.0, 0.0, 0.4, 1.0) # Damage 0 - 10
	
	#Grey
	if value >= 100:
		return Color0
	
	return Color1
