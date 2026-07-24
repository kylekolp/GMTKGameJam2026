extends System

var dashMeter : DashMeter

func _ready() -> void:
	dashMeter = SpawnDashUI()

func SpawnDashUI() -> DashMeter:
	var entityPackedScene : PackedScene = ResourceLoader.load(UIDCatalog.UI_DashBar, "PackedScene") as PackedScene
	if entityPackedScene == null:
		push_error("Spawn Dash Meter: Could not load entity as packed scene: " + UIDCatalog.UI_DashBar)
		return
		
	var newEntity = entityPackedScene.instantiate() as DashMeter
	if newEntity == null:
		push_error("Spawn Dash Meter: Loaded Entity Scene was not able to instantiate " + UIDCatalog.UI_DashBar)
		return
	
	hudRoot.add_child(newEntity)
	
	return newEntity
