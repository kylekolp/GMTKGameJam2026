extends Level

func _ready() -> void:
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Player, Vector2(100,100), self)
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Rocket, Vector2(600,600), self)
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Rocket, Vector2(800,200), self)
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Fire, Vector2(100,600), self)
