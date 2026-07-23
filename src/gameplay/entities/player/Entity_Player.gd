class_name Player
extends CharacterBody2D

@export var movement_speed : float

var currentRope: Entity_Rope
var currentRocket : Entity_Rocket

var entityRoot : Node2D

@onready var animator : AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	entityRoot = get_parent()
	return
	
func _physics_process(delta: float) -> void:
	
	var direction:= Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
	
	velocity = direction * movement_speed
	
	move_and_slide()
	
	var screen_size = get_viewport_rect().size
	var half_sprite_size = $Sprite2D.texture.get_size() * $Sprite2D.scale / 2
	
	position.x = clamp(position.x, half_sprite_size.x, screen_size.x - half_sprite_size.x)
	position.y = clamp(position.y, half_sprite_size.y, screen_size.y - half_sprite_size.y)
	

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
	
