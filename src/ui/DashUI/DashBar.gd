@tool
extends TextureProgressBar

@export var target_property : String = "property"

var tween: Tween

var currentColor : Color
var initialScale : Vector2

var oldValue : float

func _ready() -> void:
	oldValue = value
	initialScale = offset_transform_scale
	pivot_offset = Vector2(0,size.y/2)

func _set(property : StringName, value : Variant) -> bool:
	if property == target_property:
		if get(property) == value:
			return false
		animate()
		oldValue = value
		return false
	return false
	
func animate() -> void:
	
	if value == 100:
		var x = 4
	
	var valueColor : Color = GetColorBasedOnValue(value)
	
	if valueColor != currentColor:
		tint_progress = valueColor
		currentColor = valueColor
		
		var newScale = Vector2(initialScale.x + .2, initialScale.y + .2)
		
		if tween and tween.is_running():
			tween.kill()
		
		if oldValue < 100 and value == 100:
			tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)
			tween.tween_property(self, "offset_transform_scale", newScale, 0.2)
			tween.parallel().tween_property(self, "offset_transform_scale", newScale, 0.2).set_delay(0.05)
			tween.chain().tween_property(self, "offset_transform_scale", initialScale, 0.2)
			tween.parallel().tween_property(self, "offset_transform_scale", initialScale, 0.2)
	
func GetColorBasedOnValue(value: float) -> Color:
	
	var Color0 : Color = Color.from_hsv(0.0, 0.0, 1.0, 1.0) # Damage 10 - 20
	var Color1: Color = Color.from_hsv(0.0, 0.0, 0.4, 1.0) # Damage 0 - 10
	
	#Grey
	if value >= 100:
		return Color0
	
	return Color1
