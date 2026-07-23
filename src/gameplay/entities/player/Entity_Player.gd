class_name Player
extends CharacterBody2D

@export var movement_speed : float

@onready var dash : Dash = $Dash
@export var dash_speed : float

var currentRope: Entity_Rope
var currentRocket : Entity_Rocket

var entityRoot : Node2D

@onready var animator : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	entityRoot = get_parent()
	return
	
func _physics_process(delta: float) -> void:
	
	var direction:= Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
	
	AnimatePlayer(direction)
	
	if Input.is_action_just_pressed("dash"):
		dash.start_dash(dash_speed)
	
	var speed = dash_speed if dash.is_dashing() else movement_speed
	
	velocity = direction.normalized() * movement_speed * delta
	
	move_and_slide()
	
func AnimatePlayer(direction : Vector2):
	
	if direction.x < 0 and direction.y == 0:
		animator.play("Walk_Left")
	elif direction.x > 0 and direction.y == 0: #Right
		animator.play("Walk_Right")
	elif direction.x == 0 and direction.y > 0:
		animator.play("Walk_Down")
	elif direction.x == 0 and direction.y < 0:
		animator.play("Walk_Up")
	elif direction.x < 0 and direction.y < 0:
		animator.play("Walk_Diagonal_Back_Left")
	elif direction.x > 0 and direction.y < 0:
		animator.play("Walk_Diagonal_Back_Right")
	elif direction.x < 0 and direction.y > 0:
		animator.play("Walk_Diagonal_Front_LeftDown")
	elif direction.x > 0 and direction.y > 0:
		animator.play("Walk_Diagonal_Front_RightDown")
	else:
		animator.play("Idle")
		
	print("current animation: " + animator.current_animation.get_basename())
	
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
	animator.play("TakeDamage")
	if currentRope != null:
		currentRope.reset_attached_rockets()
		currentRope.BurnRope()
		currentRope = null
	
