class_name Entity_FireBurnRope
extends Node2D

var parentRope : Line2D

var movingTween : Tween

var startIndex : int = -1
var sourceRope : Entity_Rope = null
var alreadyIgnited : Array[Entity_Rope] = []

@export var timeToReachSegment : float = .1
@export var ropeCrossDistance : float = 12.0

signal FireTravelComplete(fireEntity : Node2D)

func _ready() -> void:
	parentRope = get_parent()
	if startIndex == -1:
		startIndex = parentRope.points.size() - 1
	
func _process(delta: float) -> void:
	_check_rope_crossing()
	
	if movingTween != null and movingTween.is_running():
		return
			
	movingTween  = create_tween()
	movingTween.tween_property(self, 'position', parentRope.points[startIndex], timeToReachSegment).set_trans(Tween.TRANS_LINEAR)
	
	for i in range(startIndex- 1, -1, -1):
		movingTween.chain().tween_property(self, 'position', parentRope.points[i], timeToReachSegment).set_trans(Tween.TRANS_LINEAR)
		movingTween.chain().tween_callback(parentRope.notify_ember_passed_point.bind(i))
		
	movingTween.finished.connect(FireBurnComplete)

func _check_rope_crossing() -> void:
	for other_rope in get_tree().get_nodes_in_group("Rope"):
		if other_rope == parentRope or other_rope == sourceRope or other_rope in alreadyIgnited:
			continue
		var pts : PackedVector2Array = other_rope.points
		if pts.size() < 2:
			continue
		for i in range(pts.size() - 1):
			var closest := Geometry2D.get_closest_point_to_segment(global_position, pts[i], pts[i + 1])
			if global_position.distance_to(closest) < ropeCrossDistance:
				alreadyIgnited.append(other_rope)
				other_rope.ignite_from_point(parentRope, i)
				break

func FireBurnComplete() -> void:
	FireTravelComplete.emit(self)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	var bodyGroups : Array[StringName] = body.get_groups()
	
	if "Player" in bodyGroups:
		var playerObj : Player = body as Player
		playerObj.FireDamagePlayer(self)
