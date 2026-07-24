class_name Dash
extends Node2D

var dash_cooldown : float #3 sec
@onready var durationTimer : Timer = $DurationTimer
@onready var cooldownTimer : Timer = $CooldownTimer

var ghostScene = "uid://dnsvispcn2bhp"

var ghostActive : bool = false
var ghostTime : float = 0.0
var ghostCooldown : float = .03

@onready var player : Player = get_parent()

func _process(delta : float) -> void:
	if ghostActive:
		ghostTime += delta
		if ghostTime > ghostCooldown:
			instance_ghost()
			ghostTime = 0
	return

func start_dash(duration) -> void:
	durationTimer.start(duration)
	ghostActive = true
	instance_ghost()
	
func instance_ghost():
	var dashGhost : DashGhost = SpawnGhost(player.position)
	dashGhost.StartGhost(player)
	
func is_dashing() -> bool:
	return !durationTimer.is_stopped()

func is_dash_on_cooldown() -> bool:
	return !cooldownTimer.is_stopped()
	
func SpawnGhost(position: Vector2) -> DashGhost: 
	return SpawnGhostAtPosition(ghostScene,position)
	
func SpawnGhostAtPosition(entityUID : String, position: Vector2) -> DashGhost:
	var entityPackedScene : PackedScene = ResourceLoader.load(entityUID, "PackedScene") as PackedScene
	if entityPackedScene == null:
		push_error("Ghost Spawn: Could not load entity as packed scene: " + entityUID)
		return
		
	var newEntity = entityPackedScene.instantiate() as DashGhost
	if newEntity == null:
		push_error("Ghost Spawn: Loaded Entity Scene was not able to instantiate " + entityUID)
		return
	
	get_parent().get_parent().add_child(newEntity)
	newEntity.position = position
	
	#Allow the new level to process before accessing it
	#await get_tree().process_frame
	
	return newEntity


func _on_ghost_timer_timeout() -> void:
	instance_ghost()
	pass # Replace with function body.


func _on_duration_timer_timeout() -> void:
	cooldownTimer.start(dash_cooldown)
	ghostActive = false
	pass # Replace with function body.
