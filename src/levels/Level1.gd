extends Level

@export var min_distance_from_fire: float = 150.0
@export var min_distance_from_rocket: float = 80.0
@export var min_distance_from_rope: float = 40.0
@export var min_distance_from_player: float = 100.0

func _ready() -> void:
	SignalBus.LoadSystem.emit(UIDCatalog.System_PauseAction)
	#SignalBus.LoadSystem.emit(UIDCatalog.System_Score)
	SignalBus.LoadSystem.emit(UIDCatalog.ScoreNumberSpawner)
	SignalBus.LoadUI.emit()
	#SignalBus.LoadSystem.emit(UIDCatalog.System_Lives)
	#SignalBus.LoadSystem.emit(UIDCatalog.System_DashAction)
	
	var centerOfScreen = get_viewport().get_visible_rect().size / 2
	
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Player, centerOfScreen, self)
	rocket_spawn_timer.start(rocket_spawn_interval)

func _on_rocket_spawn_timer_timeout() -> void:
	var candidate_position := Vector2(
		randf_range(rocket_spawn_area.position.x, rocket_spawn_area.end.x),
		randf_range(rocket_spawn_area.position.y, rocket_spawn_area.end.y)
	)
	
	for group in ["Fire", "Rocket"]:
		if not _is_far_enough_from_group(candidate_position, group, min_distance_from_fire):
			rocket_spawn_timer.start(failed_rocket_spawn_interval)
			return
	
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Rocket, candidate_position, self)
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.ROCKET_SPAWN)
	rocket_spawn_timer.start(rocket_spawn_interval)

func _is_far_enough_from_group(position: Vector2, group: StringName, min_distance: float) -> bool:
	for node in get_tree().get_nodes_in_group(group):
		if position.distance_to(node.global_position) < min_distance:
			return false
	return true
