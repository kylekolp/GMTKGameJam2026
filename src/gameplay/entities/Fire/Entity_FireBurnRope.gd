class_name Entity_FireBurnRope
extends Node2D

var parentRope : Line2D

var movingTween : Tween

@export var timeToReachSegment : float = .1

signal FireTravelComplete(fireEntity : Node2D)

func _ready() -> void:
	parentRope = get_parent()
	
func _process(delta: float) -> void:
	if movingTween != null and movingTween.is_running():
		return
			
	movingTween  = create_tween()
	movingTween.tween_property(self, 'position', parentRope.points[parentRope.points.size()-1], timeToReachSegment).set_trans(Tween.TRANS_LINEAR)
	
	for i in range(parentRope.points.size() - 1,0,-1):
		movingTween.chain().tween_property(self, 'position', parentRope.points[i], timeToReachSegment).set_trans(Tween.TRANS_LINEAR)
		
	movingTween.finished.connect(FireBurnComplete)
	
func FireBurnComplete() -> void:
	FireTravelComplete.emit(self)
	queue_free()
