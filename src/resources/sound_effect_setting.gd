class_name SoundEffect
extends Resource

# Different types of sound effects available to be played, instaniate with AudioManager.create_2d_audio or AudioManager.create_audio
enum SOUND_EFFECT_TYPE{ 
	PLACEHOLDER,
	FIRE,
	ROCKET_SPAWN,
	PLAYER_HIT,
	FIREWORK,
}

@export_range(0, 100) var limit: int = 5 ## Max number of SoundEffect allowed to be played
@export var type: SOUND_EFFECT_TYPE ## Unique sfx in the enum SOUND_EFFECT_TYPE
@export var sound_effect: AudioStream ## audio file to be played
@export_range (-40, 20) var volume: float = 0 ## Volume of sfx
@export_range(0.0, 4.0, 0.1) var pitch_scale: float = 1.0 # Pitch of sfx
@export_range(0.0, 1.0, 0.01) var pitch_randomness: float = 0.0 # +/- range of pitch randomization

var audio_count: int = 0 # Instances of sound_effect currently playing

func change_audio_count(amount: int):
	audio_count = max(0, audio_count + amount)

## Check if there is room for another instance
func has_open_limit() -> bool:
	return audio_count < limit

func on_audio_finished():
	change_audio_count(-1)
