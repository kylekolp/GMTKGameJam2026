class_name Player
extends CharacterBody2D

@export var movement_speed : float

var currentRope: Entity_Rope

var entityRoot : Node2D

func _ready() -> void:
	entityRoot = get_parent()
	return
	
func _physics_process(delta: float) -> void:
	var direction:= Input.get_vector("Move_Left", "Move_Right", "Move_Up", "Move_Down")
	
	velocity = direction * movement_speed
	
	move_and_slide()

func start_drawing() -> Entity_Rope:
	if currentRope == null:
		currentRope = CreateRope(Vector2(0,0))
		currentRope.RopeComplete.connect(DropRopeOnComplete)
		
	#await get_tree().process_frame
		
	currentRope.start_drawing()
	
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
