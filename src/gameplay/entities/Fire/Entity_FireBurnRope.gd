class_name Entity_FireBurnRope
extends Node2D

var parentRope : Line2D

var movingTween : Tween

var fire_sfx: AudioStreamPlayer2D

var burnDownToIndex : int = Entity_Rope.NO_BURN

@export var velocity : float

signal FireTravelComplete(fireEntity : Node2D)

func _ready() -> void:
	parentRope = get_parent()
	fire_sfx = AudioManager.create_2d_audio(position, 500, SoundEffect.SOUND_EFFECT_TYPE.FIRE)
	
func _process(delta: float) -> void:
	if fire_sfx:
		fire_sfx.position = position

	if movingTween != null and movingTween.is_running():
		return

	movingTween = create_tween()
	var previousPoint = global_position

	for i in range(parentRope.points.size() - 1, -1, -1):
		var distanceBetweenNextPoints = previousPoint.distance_to(parentRope.points[i])
		var timeToReachNext : float = distanceBetweenNextPoints / velocity
		movingTween.chain().tween_property(self, 'position', parentRope.points[i], timeToReachNext).set_trans(Tween.TRANS_LINEAR)
		movingTween.chain().tween_callback(parentRope.notify_ember_passed_point.bind(i))
		if burnDownToIndex != Entity_Rope.NO_BURN and i > burnDownToIndex:
			movingTween.chain().tween_callback(parentRope.burn_to.bind(i))
		previousPoint = parentRope.points[i]

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
