extends Line2D

@export var drawingDelayTimer: Timer

@export var fireSpawnTimer : Timer

var is_drawing := false
var target: Node2D

func _ready() -> void:
	top_level = true
	target = get_parent()

func start_drawing() -> void:
	clear_points()
	is_drawing = true

func stop_drawing() -> void:
	SignalBus.RopeComplete.emit(self)
	is_drawing = false
	fireSpawnTimer.start() #Start spawning fire

func _process(delta: float) -> void:
	if is_drawing and drawingDelayTimer.is_stopped():
		add_point(target.global_position)
		drawingDelayTimer.start(.1)


func _on_fire_spawn_timer_timeout() -> void:
	#var ropeStartPosition : Vector2 = Vector2(points[0].x,points[0].y)
	#SignalBus.loadEntity.emit(UIDCatalog.Entity_FireBurnRope,ropeStartPosition,self)
	pass # Replace with function body.
