class_name MainGame
extends Node

#Game World Root Nodes
@onready var levelRoot : Node2D = %LevelRoot
@onready var entityRoot : Node2D = %EntityRoot
@onready var effectsRoot : Node2D = %EffectsRoot

#UI Root Nodes
@onready var hudRoot : Control = %HudRoot
@onready var pauseRoot : Control = %PauseRoot
@onready var debugRoot : Control = %DebugRoot

var currentLevel : Level = null
var player : Player = null

func _ready() -> void:
	SignalBus.LoadLevel.connect(LoadLevel)
	SignalBus.LoadMenu.connect(LoadMenu)
	SignalBus.QuitGame.connect(QuitGame)
	
	LoadMenu(UIDCatalog.Menu_Main)
	
func InitializePlayer() -> void:
	var playerUID : String = UIDCatalog.Entity_Player
	var playerPackedScene : PackedScene = ResourceLoader.load(playerUID) as PackedScene
	if playerPackedScene == null:
		push_error("Could not load player scene: " + playerUID)
		return
		
	player = playerPackedScene.instantiate() as Player
	if player == null:
		push_error("Loaded Player Scene does not extend the Player class. " + playerUID)
		return
	
	entityRoot.add_child(player)
	
func LoadLevel(levelUID : Level) -> void:
	deferredLoadLevel.call_deferred(levelUID)
	
func deferredLoadLevel(levelUID : String) -> void:
	if(currentLevel != null):
		currentLevel.queue_free()
		currentLevel = null
	
	#Allow the old level to finish freeing before adding a new one
	await get_tree().process_frame
	
	var newLevelPackedScene : PackedScene = ResourceLoader.load(levelUID, "PackedScene") as PackedScene
	if newLevelPackedScene == null:
		push_error("Could not load level as packed scene: " + levelUID)
		return
		
	currentLevel = newLevelPackedScene.instantiate() as Level
	if currentLevel == null:
		push_error("Loaded Level Scene does not extend the Level class. " + levelUID)
		return
	
	levelRoot.add_child(currentLevel)
	
	#Allow the new level to process before accessing it
	await get_tree().process_frame
	
	#Move player to appropriate position within level?
	#Set up camera?
	
	return

func LoadMenu(menuUID : String) -> void:
	deferredLoadMenu.call_deferred(menuUID)
	
func deferredLoadMenu(menuUID : String) -> void:
	var newMenuPackedScene : PackedScene = ResourceLoader.load(menuUID, "PackedScene") as PackedScene
	if newMenuPackedScene == null:
		push_error("Could not menu as packed scene: " + menuUID)
		return
		
	var newMenu = newMenuPackedScene.instantiate() as Control
	if newMenu == null:
		push_error("Loaded Menu Scene was not able to instantiate " + menuUID)
		return

	#Retrieve the current menu in the hud root
	var menuChildren : Array[Node] = hudRoot.get_children()
	var currentMenu = null
	if !menuChildren.is_empty():
		currentMenu = menuChildren.back()

	if newMenu is BaseMenu:
		if(currentMenu != null):
			currentMenu.queue_free()
			currentMenu = null
	elif newMenu is BaseMenu_Sub:
		var newSub = newMenu as BaseMenu_Sub
		if currentMenu != null:
			newSub.SetParentMenu(currentMenu)
			#currentMenu.hide()
	#Else its a popup just display it over top
	
	#Allow the old level to finish freeing before adding a new one
	await get_tree().process_frame
	
	currentMenu = newMenu
	
	hudRoot.add_child(newMenu)
	
	#Allow the new level to process before accessing it
	await get_tree().process_frame
	
	return
	
func QuitGame() -> void:
	#Load Are you sure you want to quit menu
	#LoadMenu(QuitMenuUID)
	get_tree().quit()
