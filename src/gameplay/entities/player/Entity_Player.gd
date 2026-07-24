class_name Player
extends CharacterBody2D

@export var movement_speed : float

@onready var dash : Dash = $Dash
@export var dash_cooldown : float
@export var dash_speed : float
@export var dashDuration : float
var dashDirection : Vector2 = Vector2.ZERO

@export var movement_acceleration : float = 10

var currentRope: Entity_Rope
var currentRocket : Entity_Rocket

var entityRoot : Node2D

@onready var sprite : Sprite2D = $Sprite2D

@onready var animator_Movement : AnimationPlayer = $AnimationPlayerMovement
@onready var animator_Damage : AnimationPlayer = $AnimationPlayerDamage

var knockback : Vector2 = Vector2.ZERO
var knockback_timer: float = 0.0

var currentScale : Vector2

func _ready() -> void:
	entityRoot = get_parent()
	dash.dash_cooldown = dash_cooldown
	currentScale = scale
	return
	
func _physics_process(delta: float) -> void:
	
	if knockback_timer > 0.0:
		velocity = knockback
		knockback_timer -= delta
		if knockback_timer <= 0.0:
			knockback = Vector2.ZERO
		return
	
	var movementDirection = Vector2.ZERO
	
	if dash.is_dashing():
		movementDirection = dashDirection
	else:
		movementDirection = get_move_direction()
		
	AnimatePlayer(movementDirection)
	
	if Input.is_action_just_pressed("Dash") and not dash.is_dash_on_cooldown():
			dash.start_dash(dashDuration)
			dashDirection = movementDirection
	
	var speed = dash_speed if dash.is_dashing() else movement_speed
	
	velocity = velocity.lerp(movementDirection.normalized() * speed, movement_acceleration * delta)
	
	move_and_slide()

func get_move_direction() -> Vector2:
	return Vector2(
		int(Input.is_action_pressed('Move_Right')) - int(Input.is_action_pressed("Move_Left")),
		int(Input.is_action_pressed('Move_Down')) - int(Input.is_action_pressed('Move_Up'))
	)
	
func AnimatePlayer(direction : Vector2):
	
	if direction.x < 0 and direction.y == 0:
		animator_Movement.play("Walk_Left")
	elif direction.x > 0 and direction.y == 0: #Right
		animator_Movement.play("Walk_Right")
	elif direction.x == 0 and direction.y > 0:
		animator_Movement.play("Walk_Down")
	elif direction.x == 0 and direction.y < 0:
		animator_Movement.play("Walk_Up")
	elif direction.x < 0 and direction.y < 0:
		animator_Movement.play("Walk_Diagonal_Back_Left")
	elif direction.x > 0 and direction.y < 0:
		animator_Movement.play("Walk_Diagonal_Back_Right")
	elif direction.x < 0 and direction.y > 0:
		animator_Movement.play("Walk_Diagonal_Front_LeftDown")
	elif direction.x > 0 and direction.y > 0:
		animator_Movement.play("Walk_Diagonal_Front_RightDown")
	else:
		animator_Movement.play("Idle")
	
	return

func start_drawing(rocket : Entity_Rocket) -> Entity_Rope:
	currentRope = CreateRope(Vector2(0,0))
	currentRope.RopeComplete.connect(DropRopeOnComplete)
	currentRope.start_drawing()
	currentRope.attach_rocket(rocket)
	return currentRope

func attach_rocket_to_current_rope(rocket : Entity_Rocket) -> Entity_Rope:
	currentRope.attach_rocket(rocket)
	return currentRope

func hasRope() -> bool:
	return currentRope != null
	
# Used to drop rope into level
func DropRopeOnComplete(rope : Entity_Rope) -> void:
	currentRope.RopeComplete.disconnect(DropRopeOnComplete)
	rope.reparent(entityRoot)
	currentRope = null
	
func CreateRope(position: Vector2) -> Entity_Rope:
	var entityPackedScene : PackedScene = ResourceLoader.load(UIDCatalog.Entity_Rope, "PackedScene") as PackedScene
	if entityPackedScene == null:
		push_error("Player Spawn Rope: Could not load entity as packed scene")
		return
		
	var newRope = entityPackedScene.instantiate() as Entity_Rope
	if newRope == null:
		push_error("Player Spawn Rope: Loaded Entity Scene was not able to instantiate")
		return
	
	self.add_child(newRope)
	
	newRope.position = position

	return newRope
	
#push the player back a bit and burn the rope they are holding
func FireDamagePlayer(enemy : Entity_FireBurnRope) -> void:
	animator_Damage.play("TakeDamage")
	AudioManager.create_audio(SoundEffect.SOUND_EFFECT_TYPE.PLAYER_HIT)
	
	#knockback player
	var direction : Vector2 = enemy.global_position.direction_to(self.global_position).normalized()
	
	apply_knockback(direction, 2000.0, 0.04)
	
	if currentRope != null:
		currentRope.reset_attached_rockets()
		currentRope.BurnRope()
		currentRope = null
		
func apply_knockback(direction : Vector2, force: float, knockback_duration: float) -> void:
	knockback = direction * force
	knockback_timer = knockback_duration
	
	#Scale the player a bit to sell the knockback
	var knockbackTween : Tween = create_tween().set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	
	knockbackTween.tween_property(self, "scale:x", scale.x * .5, .15) #Tween the scale as well
	knockbackTween.chain().tween_property(self, "scale:y", scale.y * .8, .2).set_delay(.08) #Tween the scale as well
	knockbackTween.parallel().tween_property(self, "scale:x", currentScale.x, .2)
	knockbackTween.chain().tween_property(self, "scale:y", currentScale.y, .2)

	
	
