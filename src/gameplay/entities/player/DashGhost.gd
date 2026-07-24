class_name DashGhost
extends Sprite2D

var playerSprite : Sprite2D

func StartGhost(player : Player):
	playerSprite = player.sprite
	scale = player.sprite.scale
	flip_h = player.sprite.flip_h
		
	texture = GetPlayerTexture()
	
	var tween:Tween = self.create_tween() #Creates a Tween, as far as I know Tween as a node has been removed
	
	#Sets transition and ease for all following tweens
	tween.set_trans(Tween.TRANS_QUART) 
	tween.set_ease(Tween.EASE_OUT)

	#Tween to execute, 
	tween.tween_property(self,"modulate:a",0.0,0.3)

	# Extra: In my case I added this callback to a function named "finished", I leave it here in case you need to call a function when the upper tweens finish.
	tween.finished.connect(queue_free)

func GetPlayerTexture() -> Texture2D:
	# Create an on-the-fly texture cropped to the active frame
	var current_texture = AtlasTexture.new()
	
	current_texture.atlas = playerSprite.texture

	# Calculate the exact pixel width and height of a single frame
	var texture_width = playerSprite.texture.get_width()
	var texture_height = playerSprite.texture.get_height()
	var frame_width = texture_width / playerSprite.hframes
	var frame_height = texture_height / playerSprite.vframes

	# Map the position coordinates of the current active frame
	var column = playerSprite.frame % playerSprite.hframes
	var row = playerSprite.frame / playerSprite.hframes
	var frame_position = Vector2(column * frame_width, row * frame_height)

	# Assign the specific regional bounding box to your new texture
	current_texture.region = Rect2(frame_position, Vector2(frame_width, frame_height))

	return current_texture
