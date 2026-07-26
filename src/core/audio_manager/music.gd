extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.IntroOver.connect(_on_intro_over)
	SignalBus.StartGame.connect(_on_game_start)
	SignalBus.GameOver.connect(_on_game_over)
	SignalBus.Pause.connect(_on_pause)
	SignalBus.UnPause.connect(_on_unpause)
	var tween = create_tween()
	tween.tween_property(self, "volume_db", -3, 5.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_intro_over():
	get_stream_playback().switch_to_clip_by_name("Menu")


func _on_game_start():
	get_stream_playback().switch_to_clip_by_name("Game")

func _on_game_over():
	if stream_paused == true:
		set_stream_paused(false)
	get_stream_playback().switch_to_clip_by_name("Menu")

func _on_pause():
	get_stream_playback().switch_to_clip_by_name("Pause")

func _on_unpause():
	get_stream_playback().switch_to_clip_by_name("Game")
