extends Node2D

var sound_effect_dict: Dictionary = {}

@export var sound_effect_settings: Array[SoundEffect]

func _ready() -> void:
	for sound_effect: SoundEffect in sound_effect_settings:
		sound_effect_dict[sound_effect.type] = sound_effect


func create_2d_audio(location: Vector2, distance: int, type: SoundEffect.SOUND_EFFECT_TYPE):
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_2D_audio: AudioStreamPlayer2D = AudioStreamPlayer2D.new()
			add_child(new_2D_audio)
			new_2D_audio.position = location
			new_2D_audio.stream = sound_effect.sound_effect
			new_2D_audio.volume_db = sound_effect.volume
			new_2D_audio.max_distance = distance
			new_2D_audio.pitch_scale = sound_effect.pitch_scale
			new_2D_audio.pitch_scale += randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness)
			new_2D_audio.finished.connect(sound_effect.on_audio_finished)
			new_2D_audio.finished.connect(new_2D_audio.queue_free)
			new_2D_audio.play()
			return new_2D_audio
	else:
		push_error("Audio Manager failed to find the setting for this type ", type)

func create_audio(type: SoundEffect.SOUND_EFFECT_TYPE):
	if sound_effect_dict.has(type):
		var sound_effect: SoundEffect = sound_effect_dict[type]
		if sound_effect.has_open_limit():
			sound_effect.change_audio_count(1)
			var new_2D_audio: AudioStreamPlayer = AudioStreamPlayer.new()
			add_child(new_2D_audio)
			new_2D_audio.stream = sound_effect.sound_effect
			new_2D_audio.volume_db = sound_effect.volume
			new_2D_audio.pitch_scale = sound_effect.pitch_scale
			new_2D_audio.pitch_scale += randf_range(-sound_effect.pitch_randomness, sound_effect.pitch_randomness)
			new_2D_audio.finished.connect(sound_effect.on_audio_finished)
			new_2D_audio.finished.connect(new_2D_audio.queue_free)
			new_2D_audio.play()
	else:
		push_error("Audio Manager failed to find the setting for this type ", type)
		

func update_position(sfx: AudioStreamPlayer2D, location: Vector2):
	sfx.position = location
	

func fade_out(sfx:AudioStreamPlayer2D, duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(sfx, "volume_db", -80, duration)
	
