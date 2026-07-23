extends Level

@export var rocket_spawn_interval: float = 2.0

@onready var rocket_spawn_timer: Timer = $RocketSpawnTimer
@onready var rocket_spawn_area_top_left: Marker2D = $SpawnAreaTopLeft
@onready var rocket_spawn_area_bottom_right: Marker2D = $SpawnAreaBottomRight

var rocket_spawn_area: Rect2

func _ready() -> void:
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Player, Vector2(100,100), self)
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Fire, Vector2(100,600), self)
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Fire, Vector2(1000,600), self)
	
	rocket_spawn_area = Rect2(
		rocket_spawn_area_top_left.position,
		rocket_spawn_area_bottom_right.position - rocket_spawn_area_top_left.position
	)
	
	rocket_spawn_timer.start()

func _on_rocket_spawn_timer_timeout() -> void:
	var rocket_spawn_position := Vector2(
		randf_range(rocket_spawn_area.position.x, rocket_spawn_area.end.x),
		randf_range(rocket_spawn_area.position.y, rocket_spawn_area.end.y)
	)
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Rocket, rocket_spawn_position, self)
