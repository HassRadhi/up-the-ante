extends Control

const ENTER_OFFSET = 50
const RISE_DISTANCE = 100
const ENTER_TIME = 0.25
const FADE_TIME = 0.8

func _on_ant_airtime_success() -> void:
	_display_text("AIRTIME!!!")

func _display_text(text: String):
	var label = _create_label()
	label.text = text
	label.modulate.a = 1.0
	label.visible = true

	var start_pos = Vector2(label.position.x, get_viewport_rect().size.y + ENTER_OFFSET)
	var end_pos = Vector2(label.position.x, get_viewport_rect().size.y - RISE_DISTANCE)

	label.position = start_pos

	var tween = create_tween()
	tween.tween_property(label, "position", end_pos, ENTER_TIME).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, FADE_TIME).set_delay(0.2)
	await tween.finished
	label.queue_free() # ensures node is deleted after fade done

func _create_label() -> Label:
	var label = $PlaceholderLabel.duplicate()
	label.pivot_offset = label.size / 1.5
	label.set_rotation_degrees(randf_range(-15,15))
	add_child(label)
	return label
