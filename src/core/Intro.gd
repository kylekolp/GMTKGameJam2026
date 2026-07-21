extends Control

@export var FarmSoftPlayer : VideoStreamPlayer
@export var GMTKPlayer : VideoStreamPlayer

@export var TransitionPanel : ColorRect
@export var BackgroundPanel : ColorRect

var transitionTime : float = .75
var transitionTime2 : float = .6

var FarmSoftColor : Color = Color("111111ff") # or 11111100 without opacity
var GMTKColorOpac : Color = Color("17171700") # GMTK With Opacity at 0
var GMTKColorStart : Color = Color("111111ff") # or 17171700 without opacity
var GMTKColor : Color = Color("171717") # or 17171700 without opacity

func _ready() -> void:
	BackgroundPanel.color = FarmSoftColor
	TransitionPanel.color = FarmSoftColor
	TransitionPanel.color.a = 0.0
	await get_tree().process_frame
	PlayFarmSoftIntro()
	##PlayGMTKIntro()
#
func PlayFarmSoftIntro() -> void:
	#transitionPanel.modulate.a = 0.0 #Set Opacity to 0
	FarmSoftPlayer.visible = true
	FarmSoftPlayer.play()
	#
func _on_FarmSoft_video_stream_player_finished() -> void:
	FadeAndTransitionToGMTK()

func FadeAndTransitionToGMTK() -> void:
	await get_tree().create_timer(.5).timeout
	var fadeToBlackTween : Tween = create_tween()
	fadeToBlackTween.tween_property(TransitionPanel, "color:a", 1.0, transitionTime)
	fadeToBlackTween.finished.connect(PlayGMTKIntro) #Tween the opacity as well and queue free when its finished

func PlayGMTKIntro() -> void:
	TransitionPanel.color = GMTKColorOpac
	FarmSoftPlayer.queue_free()
	GMTKPlayer.visible = true
	await get_tree().process_frame
	GMTKPlayer.play()
	var fadeToBlackTween : Tween = create_tween().set_ease(Tween.EASE_IN)
	fadeToBlackTween.tween_property(BackgroundPanel, "color:v", .09, transitionTime2)
	#
func _on_GMTK_video_stream_player_finished() -> void:
	FadeAndTransitionToMainMenu()
	
func FadeAndTransitionToMainMenu() -> void:
	var fadeToBlackTween : Tween = create_tween()
	fadeToBlackTween.tween_property(TransitionPanel, "color:a", 1.0, transitionTime)
	fadeToBlackTween.finished.connect(SwitchToMainMenu) #Tween the opacity as well and queue free when its finished
	
func SwitchToMainMenu() -> void:
	BackgroundPanel.queue_free()
	GMTKPlayer.queue_free()
	await get_tree().create_timer(.5).timeout
	SignalBus.LoadMenu.emit(UIDCatalog.Menu_Main)
	var fadeToBlackTween : Tween = create_tween()
	fadeToBlackTween.tween_property(TransitionPanel, "color:a", 0.0, transitionTime)
	fadeToBlackTween.finished.connect(queue_free) #Tween the opacity as well and queue free when its finished
