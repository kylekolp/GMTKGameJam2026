extends Level

@export var min_distance_from_fire: float = 150.0
@export var min_distance_from_rocket: float = 80.0
@export var min_distance_from_rope: float = 40.0
@export var min_distance_from_player: float = 100.0

func _ready() -> void:
	SignalBus.LoadSystem.emit(UIDCatalog.System_PauseAction)
	SignalBus.LoadSystem.emit(UIDCatalog.System_Score)
	SignalBus.LoadSystem.emit(UIDCatalog.ScoreNumberSpawner)
	SignalBus.LoadSystem.emit(UIDCatalog.System_Lives)
	SignalBus.LoadSystem.emit(UIDCatalog.System_DashAction)
	
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Player, Vector2(100,100), self)
