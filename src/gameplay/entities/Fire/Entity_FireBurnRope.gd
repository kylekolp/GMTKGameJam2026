class_name Entity_FireBurnRope
extends Node2D

var parentRope : Entity_Rope
var movingTween : Tween
var fire_sfx: AudioStreamPlayer2D
var burnDownToIndex : int = Entity_Rope.NO_BURN
var currentIndex : int = -1

@export var velocity : float

signal FireTravelComplete(fireEntity : Node2D)

func _ready() -> void:
	parentRope = get_parent()
	fire_sfx = AudioManager.create_2d_audio(position, 500, SoundEffect.SOUND_EFFECT_TYPE.FIRE)

func _process(delta: float) -> void:
	if fire_sfx:
		fire_sfx.position = position

	if burnDownToIndex != Entity_Rope.NO_BURN:
		_process_burning(delta)
	else:
		_process_ordinary()

func _process_ordinary() -> void:
	if movingTween != null and movingTween.is_running():
		return

	movingTween = create_tween()
	var previousPoint = global_position

	for i in range(parentRope.points.size() - 1, -1, -1):
		var distanceBetweenNextPoints = previousPoint.distance_to(parentRope.points[i])
		var timeToReachNext : float = distanceBetweenNextPoints / velocity
		movingTween.chain().tween_property(self, 'position', parentRope.points[i], timeToReachNext).set_trans(Tween.TRANS_LINEAR)
		movingTween.chain().tween_callback(parentRope.notify_ember_passed_point.bind(i))
		previousPoint = parentRope.points[i]

	movingTween.finished.connect(FireBurnComplete)

func _process_burning(delta: float) -> void:
	if currentIndex == -1:
		currentIndex = parentRope.points.size() - 1

	var remaining_distance = velocity * delta

	while remaining_distance > 0 and currentIndex > burnDownToIndex:
		var target : Vector2 = parentRope.points[currentIndex]
		var distance_to_target = global_position.distance_to(target)

		if distance_to_target <= remaining_distance:
			global_position = target
			remaining_distance -= distance_to_target
			parentRope.notify_ember_passed_point(currentIndex)
			parentRope.burn_to(currentIndex)
			currentIndex -= 1
		else:
			global_position = global_position.move_toward(target, remaining_distance)
			remaining_distance = 0

	if currentIndex <= burnDownToIndex:
		FireBurnComplete()

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
