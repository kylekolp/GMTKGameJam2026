class_name UIAnimationCatalog
extends Node

var default_offset := 75
var default_duration := 0.3

func animate_slide_from_left(node: Control, viewport : Viewport, duration := default_duration, delay := 0) -> Tween:
	var originalPositionX = node.offset_transform_position.x
	
	var leftEdge = viewport.position.x - viewport.size.x
	
	node.offset_transform_position.x = leftEdge - node.size.x - default_offset
	
	var t = node.create_tween()
	t.tween_property(node, 'offset_transform_position:x', originalPositionX, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	if delay > 0:
		t.set_delay(delay)
	
	return t

func animate_slide_from_right(node: Control, viewport : Viewport, duration := default_duration, delay := 0) -> Tween:
	var originalPositionX = node.offset_transform_position.x
	
	var viewPortPosition = viewport.get_visible_rect().size.x + node.size.x / 2
	
	node.offset_transform_position.x = viewPortPosition + default_offset
	
	var t = node.create_tween()
	t.tween_property(node, 'offset_transform_position:x', originalPositionX, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	if delay > 0:
		t.set_delay(delay)
	
	return t
	
func animate_slide_from_top(node: Control, viewport : Viewport, duration := default_duration, delay := 0) -> Tween:
	var originalPositionY = node.offset_transform_position.y
	
	var topEdge = viewport.position.y - viewport.size.y
	
	node.offset_transform_position.y = topEdge - node.size.y / 2 - default_offset
	
	var t = node.create_tween()
	t.tween_property(node, 'offset_transform_position:y', originalPositionY, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	if delay > 0:
		t.set_delay(delay)
	
	return t
	
func animate_slide_from_bottom(node: Control, viewport : Viewport, duration := default_duration, delay := 0) -> Tween:
	var originalPositionY = node.offset_transform_position.y
	
	var viewPortPosition = viewport.get_visible_rect().size.y - node.size.y / 2
	
	node.offset_transform_position.y = viewPortPosition + default_offset
	
	var t = node.create_tween()
	t.tween_property(node, 'offset_transform_position:y', originalPositionY, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	
	if delay > 0:
		t.set_delay(delay)
	
	return t

func animate_pop_in(node: Control, duration := default_duration, delay := 0) -> Tween:
	node.pivot_offset.x = node.size.x / 2
	node.pivot_offset.y = node.size.y / 2
	node.offset_transform_scale = Vector2.ZERO
	
	var t = node.create_tween()
	t.tween_property(node, 'offset_transform_scale', Vector2.ONE, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	if delay > 0:
		t.set_delay(delay)

	return t
	
func animate_pop_out(node: Control, duration := default_duration, delay := 0) -> Tween:
	node.pivot_offset.x = node.size.x / 2
	node.pivot_offset.y = node.size.y / 2
	
	var t = node.create_tween()
	t.tween_property(node, 'offset_transform_scale', Vector2.ZERO, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	if delay > 0:
		t.set_delay(delay)

	return t

func animate_fade_in(node: Control, duration := default_duration, delay := 0) -> Tween:
	var originalAlpha = node.modulate.a
	
	node.modulate.a = 0.0
	
	var t = node.create_tween()
	t.tween_property(node, 'modulate:a', originalAlpha, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	if delay > 0:
		t.set_delay(delay)
		
	return t
	
func animate_fade_out(node: Control, duration := default_duration, delay := 0) -> Tween:
	
	var t = node.create_tween()
	t.tween_property(node, 'modulate:a', 0.0, duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	if delay > 0:
		t.set_delay(delay)
	
	return t
	
func animate_scale_up(node: Control, amount : float, duration := default_duration, delay := 0) -> Tween:
	
	var t = node.create_tween()
	t.set_parallel(true)
	t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(node, "offset_transform_scale:x", amount, duration)
	t.tween_property(node, "offset_transform_scale:y", amount, duration)
	
	if delay > 0:
		t.set_delay(delay)
	
	return t
	
func animate_scale_down(node: Control, amount : float, duration := default_duration, delay := 0) -> Tween:
	
	var t = node.create_tween()
	t.set_parallel(true)
	t.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	t.tween_property(node, "offset_transform_scale:x", 0, duration)
	t.tween_property(node, "offset_transform_scale:y", 0, duration)
	
	if delay > 0:
		t.set_delay(delay)
	
	return t
	
func animate_wiggle(node: Control, amount : float, duration := default_duration, delay := 0) -> Tween:
	
	var t = node.create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	#tween.tween_property(self, "transform_offset_scale:y", 0.75, 0.13) # We can use offset_transform_scale now if we want
	t.tween_property(node, "offset_transform_rotation", randf_range(5.0, 10.0) * amount * [-1.0, 1.0].pick_random(), 0.1)
	#tween.tween_property(self, "transform_offset_scale:y", 1.1, 0.15) # We can use offset_transform_scale now if we want
	t.chain().tween_property(node, "offset_transform_rotation", 0.0, 0.1)
	
	if delay > 0:
		t.set_delay(delay)
	
	return t
