class_name BaseMenu_Sub
extends Control

var parentMenu : Control

func SetParentMenu(parent : Control) -> void:
	parentMenu = parent

func _on_tree_exited() -> void:
	if parentMenu != null:
		parentMenu.show() #Reveal the parent menu that was hidden
		pass # Replace with function body.
