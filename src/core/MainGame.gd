class_name MainGame
extends Node

#Systems Root Nodes
@onready var systemsRoot : Node2D = %Systems

#Game World Root Nodes
@onready var worldRoot : Node2D = %World

@onready var levelRoot : Node2D = %LevelRoot
@onready var entityRoot : Node2D = %EntityRoot
@onready var effectsRoot : Node2D = %EffectsRoot

#UI Root Nodes
@onready var hudRoot : Control = %HudRoot
@onready var pauseRoot : Control = %PauseRoot
@onready var debugRoot : Control = %DebugRoot

var currentLevel : Level = null
var player : Player = null

var isGameOver : bool = false

func _ready() -> void:
	SignalBus.LoadLevel.connect(LoadLevel)
	SignalBus.LoadMenu.connect(LoadMenu)
	SignalBus.TryQuit.connect(TryQuit)
	SignalBus.ConfirmQuit.connect(ConfirmQuit)
	SignalBus.Pause.connect(PauseGame)
	SignalBus.UnPause.connect(UnPauseGame)
	
	SignalBus.StartGame.connect(OnStartGame)
	SignalBus.GameOver.connect(OnGameOver)
	
	SignalBus.LoadEntity.connect(LoadEntity)
	SignalBus.LoadEffect.connect(LoadEffect)
	SignalBus.LoadSystem.connect(LoadSystem)
	
	SignalBus.UnloadLevel.connect(UnloadLevel)
	
	#RunIntro()
	LoadMenu(UIDCatalog.Menu_Main)

#Runs the intro video and transitions into the main menu
func RunIntro() -> void:
	LoadMenu(UIDCatalog.Menu_Main)
	LoadMenu(UIDCatalog.Menu_Intro)
	
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
	
func LoadLevel(levelUID : String) -> void:
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
	if get_tree().paused == true:
		LoadPauseLayer(menuUID)
		return
		
	deferredLoadMenu.call_deferred(menuUID)
	
func deferredLoadMenu(menuUID : String) -> void:	
	var newMenuPackedScene : PackedScene = ResourceLoader.load(menuUID, "PackedScene") as PackedScene
	if newMenuPackedScene == null:
		push_error("Could not load menu as packed scene: " + menuUID)
		return
		
	var newMenu = newMenuPackedScene.instantiate() as Control
	if newMenu == null:
		push_error("Loaded Menu Scene was not able to instantiate " + menuUID)
		return
		
	#Avoid creating a menu that already exists
	var menuChildren : Array[Node] = hudRoot.get_children()
	for menu : Control in menuChildren:
		if menu.name == newMenu.name:
			newMenu.queue_free()
			return

	#Retrieve the current menu in the hud root
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
	
	hudRoot.add_child(newMenu)
	
	#Allow the new level to process before accessing it
	await get_tree().process_frame
	
	return
	
func LoadPauseLayer(menuUID : String) -> void:
	deferredLoadPauseLayer.call_deferred(menuUID)
	
func deferredLoadPauseLayer(menuUID : String) -> void:
	var newMenuPackedScene : PackedScene = ResourceLoader.load(menuUID, "PackedScene") as PackedScene
	if newMenuPackedScene == null:
		push_error("Could not load pause menu as packed scene: " + menuUID)
		return
		
	var newMenu = newMenuPackedScene.instantiate() as Control
	if newMenu == null:
		push_error("Loaded Pause Menu Scene was not able to instantiate " + menuUID)
		return
		
	#Avoid creating a menu that already exists
	var menuChildren : Array[Node] = pauseRoot.get_children()
	for menu : Control in menuChildren:
		if menu.name == newMenu.name:
			newMenu.queue_free()
			return

	#Retrieve the current menu in the hud root
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
	
	pauseRoot.add_child(newMenu)
	
	#Allow the new level to process before accessing it
	await get_tree().process_frame
	
	return
	
func LoadSystem(systemUID : String) -> void:
	deferredLoadSystem.call_deferred(systemUID)
	
func deferredLoadSystem(systemUID : String) -> void:
	var systemPackedScene : PackedScene = ResourceLoader.load(systemUID, "PackedScene") as PackedScene
	if systemPackedScene == null:
		push_error("Could not load system as packed scene: " + systemUID)
		return
		
	var newSystem = systemPackedScene.instantiate() as System
	if newSystem == null:
		push_error("Loaded System Scene was not able to instantiate " + systemUID)
		return
		
	#Avoid creating a system that already exists
	var systemChildren : Array[Node] = systemsRoot.get_children()
	for system : Node2D in systemChildren:
		if system.name == newSystem.name:
			newSystem.queue_free()
			return
	
	newSystem.world = worldRoot
	newSystem.hudRoot = hudRoot
	
	systemsRoot.add_child(newSystem)
	
	#Allow the new level to process before accessing it
	await get_tree().process_frame
	
	return
	
func LoadEntity(entityUID : String, position: Vector2, parent : Node2D = null) -> void:
	deferredLoadEntity.call_deferred(entityUID,position,parent)
	
func deferredLoadEntity(entityUID : String, position: Vector2, parent : Node2D = null) -> void:
	var entityPackedScene : PackedScene = ResourceLoader.load(entityUID, "PackedScene") as PackedScene
	if entityPackedScene == null:
		push_error("Could not load entity as packed scene: " + entityUID)
		return
		
	var newEntity = entityPackedScene.instantiate() as Node2D
	if newEntity == null:
		push_error("Loaded Entity Scene was not able to instantiate " + entityUID)
		return
	
	if parent == null:
		entityRoot.add_child(newEntity)
	else:
		parent.add_child(newEntity)
	
	newEntity.position = position
	
	#Allow the new level to process before accessing it
	await get_tree().process_frame
	
	return
	
func LoadEffect(effectUID : Level) -> void:
	deferredLoadEffect.call_deferred(effectUID)
	
func deferredLoadEffect(effectUID : String) -> void:
	var effectPackedScene : PackedScene = ResourceLoader.load(effectUID, "PackedScene") as PackedScene
	if effectPackedScene == null:
		push_error("Could not load effect as packed scene: " + effectUID)
		return
		
	var newEffect = effectPackedScene.instantiate() as Node2D
	if newEffect == null:
		push_error("Loaded Effect Scene was not able to instantiate " + effectUID)
		return
	
	effectsRoot.add_child(newEffect)
	
	#Allow the new level to process before accessing it
	await get_tree().process_frame
	
	return
	
func TryQuit() -> void:
	LoadMenu(UIDCatalog.Menu_Quit)
	
func ConfirmQuit() -> void:
	get_tree().quit()
	
func OnGameOver() -> void:
	if isGameOver:
		return
		
	isGameOver = true
	
	get_tree().paused = true
	
	if currentLevel != null:
		currentLevel.queue_free()
		currentLevel = null
	
	LoadPauseLayer(UIDCatalog.Menu_GameOver)
	
func OnStartGame() -> void:
	isGameOver = false
	
	LoadLevel(UIDCatalog.Level_1)
	
	if get_tree().paused:
		get_tree().paused = false;
	
func PauseGame() -> void:
	get_tree().paused = true
	LoadPauseLayer(UIDCatalog.Menu_Pause)
	
func UnPauseGame() -> void:
	get_tree().paused = false
	
	#Queue Free all pause layer menus and resume the game
	var menuChildren : Array[Node] = pauseRoot.get_children()
	for menu : Control in menuChildren:
		menu.queue_free()
	
	await get_tree().process_frame
	
func UnloadLevel() -> void:
	#Unload LevelRoot
	for item in levelRoot.get_children():
		item.queue_free()
		
	#Unload Entity Root
	for item in entityRoot.get_children():
		item.queue_free()
		
	#Unload Effects Root
	for item in effectsRoot.get_children():
		item.queue_free()
		
	#Unload Effects Root
	for item in hudRoot.get_children():
		item.queue_free()
		
	#Unload Systems Root
	for item in systemsRoot.get_children():
		item.queue_free()
		
	#Unload Audio Stuff?
