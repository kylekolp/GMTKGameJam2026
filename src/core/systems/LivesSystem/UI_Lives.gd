class_name UI_Lives
extends Control

@export var damageHaze : Sprite2D

@onready var livesIcons : Array[TextureRect] = [
	  $MarginContainer/HBoxContainer/Icon0,
	  $MarginContainer/HBoxContainer/Icon1,
	  $MarginContainer/HBoxContainer/Icon2,
]

func lostLifeAnimate() -> void:
	var tween : Tween = create_tween().set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(damageHaze, "modulate:a", 1, 0.3)
	tween.chain().tween_property(damageHaze, "modulate:a", 0, 0.5)
