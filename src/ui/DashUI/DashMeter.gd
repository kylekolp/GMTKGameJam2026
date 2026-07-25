class_name DashMeter
extends Control

@onready var dashBar : DashBar = $DashBar

var tween : Tween

func _ready() -> void:
	SignalBus.DashOnCooldown.connect(UseDashUI)
	
func UseDashUI(cooldown : float) -> void:
	dashBar.value = 0
	
	dashBar.animateUsedDash()
	
	if tween and tween.is_running():
			tween.kill()
		
	tween = create_tween().set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(dashBar, "value", 100, cooldown).finished.connect(dashBar.animateFullDash)
		
	
