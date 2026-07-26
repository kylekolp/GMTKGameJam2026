extends Node

const WINDOW := 0.6
const APPLAUSE_COOLDOWN := 5.0
const CHEER_COOLDOWN := 20.0

var burst_count := 0
var applause_ready := true
var cheer_ready := true

@onready var window_timer := Timer.new()

func _ready() -> void:
	SignalBus.RocketExploded.connect(_on_rocket_exploded)
	window_timer.one_shot = true
	window_timer.timeout.connect(_on_window_closed)
	add_child(window_timer)

func _on_rocket_exploded(_pos: Vector2, _color: Color) -> void:
	burst_count += 1
	window_timer.start(WINDOW)

func _on_window_closed() -> void:
	var count := burst_count
	burst_count = 0
	if count >= 5 and cheer_ready:
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.CROWD_CHEER)
		_start_cooldown("cheer", CHEER_COOLDOWN)
	elif count >= 2 and applause_ready and randf() < 0.6:
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.CROWD_APPLAUSE)
		_start_cooldown("applause", APPLAUSE_COOLDOWN)
	elif count == 1 and applause_ready and randf() < 0.15:
		AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.SMALL_APPLAUSE)
		_start_cooldown("applause", APPLAUSE_COOLDOWN)

func _start_cooldown(which: String, duration: float) -> void:
	if which == "cheer":
		cheer_ready = false
	else:
		applause_ready = false
	get_tree().create_timer(duration).timeout.connect(func():
		if which == "cheer":
			cheer_ready = true
		else:
			applause_ready = true
		)
