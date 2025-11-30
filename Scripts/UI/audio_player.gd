extends AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.stop_all_music.connect(_stop)
	
func _stop():
	var tween = create_tween()
	tween = tween.tween_property(self, "volume_db", -80, 2)
	await tween.finished
	stop()
