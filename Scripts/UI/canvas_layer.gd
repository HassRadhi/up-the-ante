extends CanvasLayer

@onready var blurTimer = $Blind
@onready var blur = $ColorRect

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.blur_screen.connect(_show_blur)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _show_blur():
	blurTimer.start()
	blur.visible = true

func _on_blind_timeout() -> void:
	blur.visible = false
