@tool
extends TextureProgressBar

@export var target_property : String = "property"

@onready var animator : AnimationPlayer = $AnimationPlayer

var tween: Tween

var currentColor : Color
var initialScale : Vector2

func _ready() -> void:
	initialScale = scale
	pivot_offset = Vector2(0,size.y)

func _set(property : StringName, value : Variant) -> bool:
	if property == target_property:
		if get(property) == value: 
			return false
		#animate()
		return false
	return false
	
func animate() -> void:
	var valueColor : Color = GetColorBasedOnValue(value)
	
	if valueColor != currentColor:
		tint_progress = valueColor
		currentColor = valueColor
		
		if valueColor == Color.from_hsv(0.021, 1.0, 0.983, 1.0):
			animator.play("FlashRed")
		
		var newScaleValue : float = GetScaleBasedOnValue(value)
		
		var newScaleX : float = newScaleValue + initialScale.x
		var newScaleY : float = newScaleValue + initialScale.x
		
		if tween and tween.is_running():
			tween.kill()
		
		tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale:x", newScaleX, .25)
		tween.parallel().tween_property(self, "scale:y", newScaleY, .25).set_delay(.05)
		
		var rotation : float = GetRotationBasedOnScale(value)
		
		var tween2 = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween2.tween_property(self, "rotation_degrees", -rotation, .1)
		tween2.chain().tween_property(self, "rotation_degrees", rotation, .1)
		tween2.chain().tween_property(self, "rotation_degrees", 0, .1)
	
	#Bounce the scale up as well
	
	#label_settings.font_color = randomColor
	#pivot_offset = size / 2.0
	#if tween and tween.is_running():
		#tween.kill()
	#tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	#tween.tween_property(self, "scale:x", 1.2, 0.1)
	#tween.parallel().tween_property(self, "scale:y", 1.2, 0.15)
	#tween.parallel().tween_property(self, "rotation_degrees", 15.0 * [-1.0, 1.0].pick_random(), 0.1)
	#tween.parallel().tween_property(self, "scale:x", 1.0, 0.2).set_delay(0.2)
	#tween.parallel().tween_property(self, "scale:y", 1.0, 0.3).set_delay(0.25)
	#tween.parallel().tween_property(self, "rotation_degrees", 0.0, 0.1).set_delay(0.15)
	
	
func GetColorBasedOnValue(value: float) -> Color:
	
	var Color0 : Color = Color.from_hsv(0.25, 0.0, 0.348, 1.0) # Damage 0 - 10
	var Color1 : Color = Color.from_hsv(0.133, 1.0, 0.98, 1.0) # Damage 10 - 20
	var Color2 : Color = Color.from_hsv(0.099, 1.0, 0.932, 1.0) # Damage 20 - 30
	var Color3 : Color = Color.from_hsv(0.021, 1.0, 0.983, 1.0) # Damage 20 - 30
	
	var newColor : Color
	
	#Grey
	if value <= 100 && value > 60:
		return Color0
	
	#Yellow
	if value <= 60 && value > 40: 
		return Color1
		
	#Orange
	if value <= 40 && value > 25: 
		return Color2
		
	#Red
	if value <= 25: 
		return Color3
	
	return Color.WHITE
	
func GetScaleBasedOnValue(value: float) -> float:
	
	#Grey
	if value <= 100 && value > 60:
		return 0
	
	#Yellow
	if value <= 60 && value > 40: 
		return .4
		
	#Orange
	if value <= 40 && value > 25: 
		return .8
		
	#Red
	if value <= 25: 
		return 1
	
	return 0
	
func GetRotationBasedOnScale(value: float) -> float:
	
	#Grey
	if value <= 100 && value > 60:
		return 8
	
	#Yellow
	if value <= 60 && value > 40: 
		return 10
		
	#Orange
	if value <= 40 && value > 25: 
		return 11
		
	#Red
	if value <= 25: 
		return 12
	
	return 0
