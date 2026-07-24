class_name SystemLives
extends System

const MAX_MISSES := 3

var missesRemaining : int
var UILives: UI_Lives
var livesLabel : Label

func _ready() -> void:
	SignalBus.RocketMissed.connect(OnRocketMissed)
	UILives = SpawnLivesUI()
	livesLabel = UILives.livesValue
	ResetLives()

func ResetLives() -> void:
	missesRemaining = MAX_MISSES
	livesLabel.text = str(missesRemaining)

func OnRocketMissed() -> void:
	missesRemaining -= 1
	livesLabel.text = str(missesRemaining)
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
