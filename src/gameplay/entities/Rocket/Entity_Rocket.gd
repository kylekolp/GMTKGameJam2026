class_name Entity_Rocket
extends Node2D

@onready var circle_timer: TextureProgressBar = $CircleTimer

@export var countdownTime : float = 60.0 # debug

var countdown_tween : Tween
var hasRope : bool = false

var rope : Entity_Rope

@onready var sprite : Sprite2D = $Sprite2D

enum RocketColor {ROCKET_BLUE,ROCKET_GREEN,ROCKET_LIGHTBLUE,ROCKET_ORANGE,ROCKET_PINK,ROCKET_VIOLET,ROCKET_YELLOW}

func _ready() -> void:
	
	var randomColor : RocketColor = randi_range(0,6) as RocketColor
	var randomTexture : Texture2D = GetTexture2DForRocketColor(randomColor)
	sprite.texture = randomTexture
	
	circle_timer.value = circle_timer.max_value
	countdown_tween = create_tween()
	countdown_tween.tween_property(circle_timer, "value", 0.0, countdownTime)
	countdown_tween.finished.connect(_on_countdown_finished)

func _on_countdown_finished() -> void:
	if hasRope and rope != null and not rope.is_drawing:
		return
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
	elif body.currentRope.is_drawing:
		rope = body.attach_rocket_to_current_rope(self)
		hasRope = true
	else:
		return
	
	rope.RopeComplete.connect(_on_rope_complete)

func _on_rope_complete(rope : Node2D) -> void:
	rope.RopeComplete.disconnect(_on_rope_complete)
	countdown_tween.kill()
	circle_timer.queue_free()

func launch() -> void:
	#Play firework launch animation
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.FIREWORK)
	queue_free()
	
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
