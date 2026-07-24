class_name ScoreSystem
extends System

var score : int

var UIScore : UI_Score
var scoreLabel : Label

func _ready() -> void:
	SignalBus.AddScore.connect(AddScore)
	SignalBus.SubtractScore.connect(SubtractScore)
	SignalBus.ResetScore.connect(ResetScore)
	SignalBus.StartGame.connect(ResetScore)

	
	UIScore = SpawnScoreUI()
	scoreLabel = UIScore.scoreValue
	
	ResetScore()

func AddScore(value : int, source : Node2D):
	score += value
	scoreLabel.text = str(score)
	return
	
func SubtractScore(value : int, source : Node2D):
	score -= value
	scoreLabel.text = str(score)
	return
	
func ResetScore():
	score = 0
	scoreLabel.text = str(score)
	return
	
func SpawnScoreUI() -> UI_Score:
	var entityPackedScene : PackedScene = ResourceLoader.load(UIDCatalog.UI_Score, "PackedScene") as PackedScene
	if entityPackedScene == null:
		push_error("Spawn Score: Could not load entity as packed scene: " + UIDCatalog.UI_Score)
		return
		
	var newEntity = entityPackedScene.instantiate() as UI_Score
	if newEntity == null:
		push_error("Spawn Score: Loaded Entity Scene was not able to instantiate " + UIDCatalog.UI_Score)
		return
	
	hudRoot.add_child(newEntity)
	
	return newEntity
