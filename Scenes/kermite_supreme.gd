extends Label

signal enable_player

@onready var sound = get_parent().get_node("AudioPlayer")
@onready var screenPosition = position

func _ready():
	visible = true
	play_swipe_sequence()
	
func get_left_offscreen() -> Vector2:
	return Vector2(-size.x * 2, screenPosition.y)

func get_right_offscreen() -> Vector2:
	return Vector2(get_viewport().get_visible_rect().size.x + size.x * 2, screenPosition.y)
	
func play_swipe_sequence():
	var tween = create_tween()

	position = get_left_offscreen()
	modulate.a = 1.0

	# Swipe IN
	tween.tween_property(self, "position", screenPosition, 0.3)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_OUT)
		
	var driftPos = screenPosition + Vector2(10, 0)
	tween.parallel().tween_property(self, "position", driftPos, 3.0)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)

	tween.tween_interval(1.5)

	tween.tween_property(self, "position", get_right_offscreen(), 1)\
		.set_trans(Tween.TRANS_QUAD)\
		.set_ease(Tween.EASE_IN)
	
	await tween.finished
	
	enable_player.emit()
	sound.play()
	queue_free()
