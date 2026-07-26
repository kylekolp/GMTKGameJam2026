extends BaseMenu_Sub

@onready var tutorial_step_1 : Control = $HowToPlayStep1
@onready var tutorial_step_2 : Control = $HowToPlayStep2
@onready var tutorial_step_3 : Control = $HowToPlayStep3
@onready var tutorial_step_4 : Control = $HowToPlayStep4
@onready var tutorial_step_5 : Control = $HowToPlayStep5
@onready var tutorial_step_6 : Control = $HowToPlayStep6
@export var finalButton : Button

func _on_skip_tutorial_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	if parentMenu == null:
		SignalBus.StartGame.emit()
	queue_free()

func _on_continue_step1_button_pressed() -> void:
	tutorial_step_1.visible = false
	tutorial_step_2.visible = true
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	
func _on_continue_step2_button_pressed() -> void:
	tutorial_step_2.visible = false
	tutorial_step_3.visible = true
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	
func _on_continue_step3_button_pressed() -> void:
	tutorial_step_3.visible = false
	tutorial_step_4.visible = true
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	
func _on_continue_step4_button_pressed() -> void:
	tutorial_step_4.visible = false
	tutorial_step_5.visible = true
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	
func _on_continue_step5_button_pressed() -> void:
	if parentMenu != null:
		finalButton.text = "Exit"
	else:
		finalButton.text = "Lets Play!"
		
	tutorial_step_5.visible = false
	tutorial_step_6.visible = true
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)

func _on_back_step2_button_pressed() -> void:
	tutorial_step_2.visible = false
	tutorial_step_1.visible = true
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)

func _on_back_step3_button_pressed() -> void:
	tutorial_step_3.visible = false
	tutorial_step_2.visible = true
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)

func _on_back_step4_button_pressed() -> void:
	tutorial_step_4.visible = false
	tutorial_step_3.visible = true
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)

func _on_back_step5_button_pressed() -> void:
	tutorial_step_5.visible = false
	tutorial_step_4.visible = true
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)

func _on_back_step6_button_pressed() -> void:
	tutorial_step_6.visible = false
	tutorial_step_5.visible = true
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)

func _on_LetsPlay_button_pressed() -> void:
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLACEHOLDER)
	if parentMenu == null:
		SignalBus.StartGame.emit()
	queue_free()
