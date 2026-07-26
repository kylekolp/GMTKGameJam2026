class_name Menu_Main
extends BaseMenu

@onready var BackgroundParent : Node2D = $Backgrounds
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@export var crowdAudioPlayer : AudioStreamPlayer

var isFirstRun : bool = true

func _ready() -> void:
	SignalBus.IntroOver.connect(IntroOver)

func _on_start_button_pressed() -> void:
	SignalBus.StartGame.emit()
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	queue_free()
	
func _on_controls_button_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	SignalBus.LoadMenu.emit(UIDCatalog.Menu_Tutorial)

func _on_options_button_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	SignalBus.LoadMenu.emit(UIDCatalog.Menu_Options)


func _on_quit_button_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	SignalBus.TryQuit.emit()

func RunStartAnimation(isFirstRun : bool):
	if !isFirstRun:
		var anim: Animation = animationPlayer.get_animation("MoveBackground")
		
		var animTrackFirework : int = anim.track_find_key(29,11.35)
		var animTrackAudience : int = anim.track_find_key(32,11.2)
		
		if animTrackFirework != -1:
			anim.track_remove_key(29, animTrackFirework)
			
		if animTrackAudience != -1:
			anim.track_remove_key(32, animTrackAudience)
		
		animationPlayer.play("MoveBackground")
		animationPlayer.seek(10.3,true)
		await get_tree().create_timer(3.1).timeout
		animationPlayer.play("Idle")
	else:
		animationPlayer.play("MoveBackground")
		animationPlayer.seek(5,true)
		await get_tree().create_timer(6.7).timeout
		animationPlayer.play("Idle")
		SignalBus.MainMenuIntroRan.emit()
		
func IntroOver() -> void:
	RunStartAnimation(isFirstRun)
