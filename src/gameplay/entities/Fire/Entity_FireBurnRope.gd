class_name Entity_FireBurnRope
extends Node2D

var parentRope : Line2D

var movingTween : Tween

var fire_sfx: AudioStreamPlayer2D

@export var timeToReachSegment : float = .1


signal FireTravelComplete(fireEntity : Node2D)

func _ready() -> void:
	parentRope = get_parent()
	fire_sfx = AudioManager.create_2d_audio(position, 500, SoundEffect.SOUND_EFFECT_TYPE.FIRE)
	
func _process(delta: float) -> void:
	
	if fire_sfx:
		fire_sfx.position = position

	if movingTween != null and movingTween.is_running():
		return
			
	movingTween  = create_tween()
	movingTween.tween_property(self, 'position', parentRope.points[parentRope.points.size()-1], timeToReachSegment).set_trans(Tween.TRANS_LINEAR)
	
	for i in range(parentRope.points.size() - 1, -1, -1):
		movingTween.chain().tween_property(self, 'position', parentRope.points[i], timeToReachSegment).set_trans(Tween.TRANS_LINEAR)
		movingTween.chain().tween_callback(parentRope.notify_ember_passed_point.bind(i))
		
	movingTween.finished.connect(FireBurnComplete)
	
func FireBurnComplete() -> void:
	FireTravelComplete.emit(self)
	if fire_sfx:
		AudioManager.fade_out(fire_sfx, 2.0)
	queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:
	var bodyGroups : Array[StringName] = body.get_groups()
	
	if "Player" in bodyGroups:
		var playerObj : Player = body as Player
		playerObj.FireDamagePlayer(self)
