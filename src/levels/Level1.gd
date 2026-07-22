extends Level

func _ready() -> void:
	SignalBus.LoadEntity.emit(UIDCatalog.Entity_Player)
