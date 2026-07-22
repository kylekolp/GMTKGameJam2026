@tool
extends Control

enum WhenToTriggerItem { MANUAL, READY, QUEUEFREE, HOVER_IN, HOVER_OUT }
@export var When_To_Trigger : WhenToTriggerItem

enum AnimationTypeItem { POP_IN, POP_OUT, SLIDE_IN_LEFT, SLIDE_IN_RIGHT, SLIDE_IN_TOP, SLIDE_IN_BOTTOM, FADE_IN, FADE_OUT, SCALE_UP, SCALE_DOWN, WIGGLE }
@export var Animation_Type : AnimationTypeItem

@export_range(0, 10) var Delay : float;

@export_range(0, 10) var Duration : float;

@export var Amount : float;

#@export var Animate_Children: bool = false:
	#set(value):
		#Animate_Children = value
		## Notify the editor to refresh the layout when clicked
		#notify_property_list_changed() 
#
#enum ChildrenAnimationOrder { Top_To_Bottom, Bottom_To_Top }
#@export var Animate_Children_Order : ChildrenAnimationOrder
#
#@export_range(0, 10) var Animate_Children_Delay : float

var _animationCatalog : UIAnimationCatalog

var _parent : Node

var _tween : Tween

# Built-in function to modify property visibility dynamically
#func _validate_property(property: Dictionary) -> void:
	#if (property.name == "Animate_Children_Order" || property.name == "Animate_Children_Delay") and not Animate_Children:
		## Hide movement_speed from inspector if the toggle is off
		#property.usage = PROPERTY_USAGE_NO_EDITOR 


func _ready() -> void:
	
	_animationCatalog = UIAnimationCatalog.new()
	
	_parent = get_parent() as Control
	
	_parent.pivot_offset_ratio = Vector2(0.5, 0.5)
	_parent.offset_transform_pivot_ratio = Vector2(0.5, 0.5)
	
	match When_To_Trigger:
		WhenToTriggerItem.READY:
			_parent.ready.connect(StartTween)
		WhenToTriggerItem.QUEUEFREE:
			_parent.tree_exited.connect(StartTween)
		WhenToTriggerItem.HOVER_IN:
			_parent.mouse_entered.connect(StartTween)
		WhenToTriggerItem.HOVER_OUT:
			_parent.mouse_exited.connect(StartTween)
		WhenToTriggerItem.MANUAL:
			#Do Nothing Trigger it yourself
			pass
		_:
			push_error("ContainerTween: Invalid Trigger Type {" + name + "}")
			
func StartTween() -> void:
	
	if _tween and _tween.is_running():
		_tween.kill()
	
	match Animation_Type:
		AnimationTypeItem.SLIDE_IN_LEFT:
			_tween = _animationCatalog.animate_slide_from_left(_parent,get_viewport(),Duration,Delay)
		AnimationTypeItem.SLIDE_IN_RIGHT:
			_tween = _animationCatalog.animate_slide_from_right(_parent,get_viewport(),Duration,Delay)
		AnimationTypeItem.SLIDE_IN_TOP:
			_tween = _animationCatalog.animate_slide_from_top(_parent,get_viewport(),Duration,Delay)
		AnimationTypeItem.SLIDE_IN_BOTTOM:
			_tween = _animationCatalog.animate_slide_from_bottom(_parent,get_viewport(),Duration,Delay)
		AnimationTypeItem.POP_IN:
			_tween = _animationCatalog.animate_pop_in(_parent,Duration,Delay)
		AnimationTypeItem.POP_OUT:
			_tween = _animationCatalog.animate_pop_out(_parent,Duration,Delay)
		AnimationTypeItem.FADE_IN:
			_tween = _animationCatalog.animate_fade_in(_parent,Duration,Delay)
		AnimationTypeItem.FADE_OUT:
			_tween = _animationCatalog.animate_fade_out(_parent,Duration,Delay)
		AnimationTypeItem.SCALE_UP:
			_tween = _animationCatalog.animate_scale_up(_parent,Amount,Duration,Delay)
		AnimationTypeItem.SCALE_DOWN:
			_tween = _animationCatalog.animate_scale_down(_parent,Amount,Duration,Delay)
		AnimationTypeItem.WIGGLE:
			_tween = _animationCatalog.animate_wiggle(_parent,Amount,Duration,Delay)
		_:
			push_error("ContainerTween: Invalid Animation Type {" + name + "}")
	return
