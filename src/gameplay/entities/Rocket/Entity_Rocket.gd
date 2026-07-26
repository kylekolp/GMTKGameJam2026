class_name Entity_Rocket
extends Node2D

@onready var circle_timer: TextureProgressBar = $CircleTimer

@export var countdownTime : float = 10.0 # initial tuning, maybe shorten over time while decreasing rocket spawn intervals

var countdown_tween : Tween
var hasRope : bool = false

var rope : Entity_Rope

@onready var sprite : Sprite2D = $Sprite2D

enum RocketColor {ROCKET_BLUE,ROCKET_GREEN,ROCKET_LIGHTBLUE,ROCKET_ORANGE,ROCKET_PINK,ROCKET_VIOLET,ROCKET_YELLOW}

var shaderMaterial : ShaderMaterial

const ROCKET_COLOR_VALUES := {
	RocketColor.ROCKET_BLUE: Color("1521D3"),
	RocketColor.ROCKET_GREEN: Color("05B81C"),
	RocketColor.ROCKET_LIGHTBLUE: Color("07DAC1"),
	RocketColor.ROCKET_ORANGE: Color("F3680A"),
	RocketColor.ROCKET_PINK: Color("A6094B"),
	RocketColor.ROCKET_VIOLET: Color("6309CA"),
	RocketColor.ROCKET_YELLOW: Color("EBF205"),
}

var rocket_color : RocketColor

func _ready() -> void:
	shaderMaterial = sprite.material

	rocket_color = randi_range(0,6) as RocketColor
	sprite.texture = GetTexture2DForRocketColor(rocket_color)
	
	circle_timer.value = circle_timer.max_value
	countdown_tween = create_tween()
	countdown_tween.tween_property(circle_timer, "value", 0.0, countdownTime)
	countdown_tween.finished.connect(_on_countdown_finished)
	
func _on_countdown_finished() -> void:
	if hasRope and rope != null and not rope.is_drawing:
		return
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.TICK_LAST) # Sound Effect missed rocket
	queue_free()
	SignalBus.RocketMissed.emit()

func _on_area_2d_body_entered(body: Node2D) -> void:
	var bodyGroups : Array[StringName] = body.get_groups()
	
	if "Player" not in bodyGroups or hasRope:
		return
	
	if not body.hasRope():
		rope = body.start_drawing(self)
		if rope == null:
			return
		hasRope = true
		AnimateSelection()
	elif body.currentRope.is_drawing:
		rope = body.attach_rocket_to_current_rope(self)
		AnimateSelection()
		hasRope = true
	else:
		return
	
	rope.RopeComplete.connect(_on_rope_complete)

func _on_rope_complete(rope : Node2D) -> void:
	shaderMaterial.set_shader_parameter("show_outline",false)
	rope.RopeComplete.disconnect(_on_rope_complete)
	countdown_tween.kill()
	circle_timer.queue_free()

func launch() -> void:
	shaderMaterial.set_shader_parameter("show_outline",false)
	shaderMaterial.set_shader_parameter("wind_strength",0)
	
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.FIREWORK_LAUNCH)
	
	var launch_tween := create_tween()
	launch_tween.tween_property(self, "scale", scale * Vector2(1.2, 0.8), 0.12)
	launch_tween.tween_property(self, "scale", scale * Vector2(0.9, 1.1), 0.08)
	launch_tween.tween_property(self, "position:y", -2000.0, 0.9).as_relative().set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	launch_tween.tween_callback(_explode)

func _explode() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.FIREWORK)
	SignalBus.RocketExploded.emit(global_position, ROCKET_COLOR_VALUES[rocket_color])
	queue_free()
	
func AnimateSelection() -> void:
	shaderMaterial.set_shader_parameter("show_outline",true)
	var originalScale = scale
	var newScale = Vector2(scale.x + .2,scale.y + .2)
	
	var tween : Tween = create_tween().set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(self, "scale", newScale, 0.1)
	tween.chain().tween_property(self, "scale", originalScale, 0.1)
	
#enum RocketColor {ROCKET_BLUE,ROCKET_GREEN,ROCKET_LIGHTBLUE,ROCKET_ORANGE,ROCKET_PINK,ROCKET_VIOLET,ROCKET_YELLOW}
	
func GetTexture2DForRocketColor(color : RocketColor) -> Texture2D:
	match color:
		RocketColor.ROCKET_BLUE:
			return ResourceLoader.load("uid://byyyvqqj8i6m2") as Texture2D
		RocketColor.ROCKET_GREEN:
			return ResourceLoader.load("uid://bjtuq677ti3lw") as Texture2D
		RocketColor.ROCKET_LIGHTBLUE:
			return ResourceLoader.load("uid://bcswajgketda2") as Texture2D
		RocketColor.ROCKET_ORANGE:
			return ResourceLoader.load("uid://bambnh6rnpmtm") as Texture2D
		RocketColor.ROCKET_PINK:
			return ResourceLoader.load("uid://bjvnnc1dry6qx") as Texture2D
		RocketColor.ROCKET_VIOLET:
			return ResourceLoader.load("uid://b2ke08klwxlqn") as Texture2D
		RocketColor.ROCKET_YELLOW:
			return ResourceLoader.load("uid://bjd31lmwol00e") as Texture2D
		_:
			return ResourceLoader.load("uid://bjvnnc1dry6qx") as Texture2D
