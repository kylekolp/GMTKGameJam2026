class_name DashMeter
extends Control

@onready var dashBar : TextureProgressBar = $DashBar

var tween : Tween

func _ready() -> void:
	SignalBus.DashOnCooldown.connect(UseDashUI)
	
func UseDashUI(cooldown : float) -> void:
	dashBar.value = 0
	
	await get_tree().process_frame
	
	if tween and tween.is_running():
			tween.kill()
		
	tween = create_tween().set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_IN)
	tween.tween_property(dashBar, "value", 100, cooldown)
		
	
