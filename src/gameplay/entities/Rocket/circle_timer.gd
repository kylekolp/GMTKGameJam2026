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
	#value_changed.connect(rocket_countdown)

#func rocket_countdown(value): ## UNCOMMENT FOR THE TICKING NOISE (ALSO UNCOMMENT THE value_changed.connect(rocket_counddown) LINE
	#if value < 5:
		#return
	#if animator.current_animation == "FlashRed":
		#if fmod(value, 10) == 0:
			#AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.TICK)
		#elif fmod(value, 10) == 5:
			#AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.TOCK)

func _set(property : StringName, value : Variant) -> bool:
	if property == target_property:
		if get(property) == value: 
			return false
		animate(value)
		return false
	return false
	
func animate(newValue : float) -> void:
	var valueColor : Color = GetColorBasedOnValue(newValue)
	
	if valueColor != currentColor:
		tint_progress = valueColor
		currentColor = valueColor
		if currentColor == Color.from_hsv(0.133, 1.0, 0.98, 1.0) or currentColor == Color.from_hsv(0.099, 1.0, 0.932, 1.0):
			AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.POP)
		
		if valueColor == Color.from_hsv(0.021, 1.0, 0.983, 1.0):
			if not animator.is_playing():
				animator.play("FlashRed")
				AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.TIMER_LOW)
		else:
			if animator.is_playing():
				animator.stop()
		
		var newScaleValue : float = GetScaleBasedOnValue(value)
		
		var newScaleX : float = newScaleValue + initialScale.x
		var newScaleY : float = newScaleValue + initialScale.x
		
		if tween and tween.is_running():
			tween.kill()
		
		tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale:x", newScaleX, .25)
		tween.parallel().tween_property(self, "scale:y", newScaleY, .25).set_delay(.05)
		
		var rotation : float = GetRotationBasedOnScale(newValue)
		
		var tween2 = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween2.tween_property(self, "rotation_degrees", -rotation, .1)
		tween2.chain().tween_property(self, "rotation_degrees", rotation, .1)
		tween2.chain().tween_property(self, "rotation_degrees", 0, .1)
	
	
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
		return .6
		
	#Red
	if value <= 25: 
		return .8
	
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
