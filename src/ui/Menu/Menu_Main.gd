class_name Menu_Main
extends BaseMenu

@onready var BackgroundParent : Node2D = $Backgrounds
@onready var animationPlayer : AnimationPlayer = $AnimationPlayer

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
		animationPlayer.play("MoveBackground")
		animationPlayer.seek(10.3,true)
	else:
		animationPlayer.play("MoveBackground")
		animationPlayer.seek(5,true)
		
func IntroOver() -> void:
	RunStartAnimation(isFirstRun)


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	SignalBus.MainMenuIntroRan.emit()
