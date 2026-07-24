class_name SystemLives
extends System

const MAX_MISSES := 3

var missesRemaining : int
var UILives: UI_Lives

func _ready() -> void:
	SignalBus.RocketMissed.connect(OnRocketMissed)
	SignalBus.StartGame.connect(ResetLives)
	UILives = SpawnLivesUI()
	ResetLives()

func ResetLives() -> void:
	missesRemaining = MAX_MISSES
	for icon in UILives.livesIcons:
		icon.visible = true

func OnRocketMissed() -> void:
	missesRemaining -= 1
	var usedIndex := MAX_MISSES - missesRemaining - 1
	if usedIndex >= 0 and usedIndex < UILives.livesIcons.size():
		UILives.livesIcons[usedIndex].visible = false
	if missesRemaining <= 0:
		SignalBus.GameOver.emit()

func SpawnLivesUI() -> UI_Lives:
	var entityPackedScene : PackedScene = ResourceLoader.load(UIDCatalog.UI_Lives, "PackedScene") as PackedScene
	if entityPackedScene == null:
		push_error("Lives UI: Could not load entity as packed scene: " + UIDCatalog.UI_Lives)
		return
		
	var newEntity = entityPackedScene.instantiate() as UI_Lives
	if newEntity == null:
		push_error("Lives UI: Loaded Entity Scene was not able to instantiate " + UIDCatalog.UI_Lives)
		return
	
	hudRoot.add_child(newEntity)
	
	return newEntity
