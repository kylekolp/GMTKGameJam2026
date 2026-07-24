class_name Particle_DamageNumber
extends Node2D

@export var labelSettings : LabelSettings
@export var criticalColor : Color = Color.RED

var currentHue: float = 0.0
var currentSaturation: float = 0.0
var currentValue : float = 0.0

func SpawnLabel(number: float, isCritical : bool = false) -> void:
	var newLabel : Label = Label.new()
	
	newLabel.text = str(number if step_decimals(number) != 0 else number as int)
	newLabel.label_settings = labelSettings.duplicate()
	newLabel.z_index = 1000
	newLabel.pivot_offset_ratio = Vector2(0.5,1.0)
	
	#if isCritical:
		#newLabel.label_settings.font_color = criticalColor
	newLabel.label_settings.font_color = GetNextColor(number)

	add_child.call_deferred(newLabel)
	
	await newLabel.resized
	
	newLabel.position -= Vector2(newLabel.size.x / 2.0, newLabel.size.y)
	
	#add a slight offset to the spawn position
	newLabel.position += Vector2(randf_range(-10.0,10.0),randf_range(-5.0,5.0))
	
	#Size based on number
	var scaleNumber : float = number * .5
	if scaleNumber < .75:
		scaleNumber = .75
		
	if scaleNumber > 1:
		scaleNumber = 1
		
	var size : Vector2 = Vector2.ONE * (scaleNumber)
	
	#Animate the label to float away
	var targetRisePos : Vector2 = newLabel.position + Vector2(randf_range(-22.0,22.0), randf_range(-65.0,-75.0))
	var tweenLength : float = 0.92
	var labelTween : Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	labelTween.tween_property(newLabel, "position", targetRisePos, tweenLength) #Tween the position
	labelTween.parallel().tween_property(newLabel, "scale", size * 1.35, tweenLength) #Tween the scale as well
	#labelTween.parallel().tween_property(newLabel, "modulate:a", 0.8, tweenLength)
	labelTween.finished.connect(newLabel.queue_free) #Tween the opacity as well and queue free when its finished
	
	
func GetNextColor(value: float) -> Color:
	
	var Color0 : Color = Color.from_hsv(0.0, 0.0, 1, 1.0) # Damage 0 - 10
	var Color1 : Color = Color.from_hsv(0.144, 1.0, 1.0, 1.0) # Damage 10 - 20
	var Color2 : Color = Color.from_hsv(0.083, 1.0, 1.0, 1.0) # Damage 20 - 30
	var Color3 : Color = Color.from_hsv(0.878, 1.0, 1.0, 1.0)  # Damage 30 - 40
	var Color4 : Color = Color.from_hsv(0.781, 1.0, 1.0, 1.0) # Damage 40 - 50
	
	var newColor : Color
	
	var weight : float = 0.0
	
	if value < 10:
		return Color0
		
	#Yellow
	if value >= 10 && value < 20:
		return Color1
	
	#Orange
	if value >= 20 && value < 30: 
		return Color2
		
	#Red
	if value >= 30 && value < 40: 
		return Color3
		
	#Purple
	if value >= 40 && value < 50: 
		return Color4
	
	#Purple
	if value >= 50: 
		return Color4
	
	return Color.WHITE
