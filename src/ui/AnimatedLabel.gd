@tool
extends Label

@export var target_property : String = "property"

var tween: Tween

func _set(property : StringName, value : Variant) -> bool:
	if property == target_property:
		if get(property) == value: 
			return false
		animate()
		return false
	return false
	
func animate() -> void:
	var randomColor : Color = GetRandomColor()
	label_settings.font_color = randomColor
	pivot_offset = size / 2.0
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale:x", 1.2, 0.1)
	tween.parallel().tween_property(self, "scale:y", 1.2, 0.15)
	tween.parallel().tween_property(self, "rotation_degrees", 15.0 * [-1.0, 1.0].pick_random(), 0.1)
	tween.parallel().tween_property(self, "scale:x", 1.0, 0.2).set_delay(0.2)
	tween.parallel().tween_property(self, "scale:y", 1.0, 0.3).set_delay(0.25)
	tween.parallel().tween_property(self, "rotation_degrees", 0.0, 0.1).set_delay(0.15)
	
func GetRandomColor() -> Color:
	var randomNumber : int = randi_range(0,9)
	
	match randomNumber:
		0:
			return Color.RED
		1:
			return Color.BLUE
		2:
			return Color.GREEN
		3:
			return Color.YELLOW
		4:
			return Color.PURPLE
		5:
			return Color.AQUA
		6:
			return Color.ORANGE
		7:
			return Color.MAGENTA
		8:
			return Color.BROWN
		9:
			return Color.WHITE
		_:
			return Color.WHITE
