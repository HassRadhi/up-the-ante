extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var image = Image.create_empty(300, 1, false, Image.FORMAT_RGB8)
	image.fill(Color(1,0,0,0.5))
	var imageText = ImageTexture.create_from_image(image)
	
	texture = imageText
