extends Control

const ENTER_OFFSET = 50
const RISE_DISTANCE = 100
const ENTER_TIME = 0.25
const FADE_TIME = 0.8
const OFFSETS = [Vector2(0, 0), Vector2(-50, -50), Vector2(50, -50)]

@onready var comboTimer = $SameCombo
var lastTrick := Utils.Tricks.None
var combo = 1

var offsetIndex = 0

func _on_ant_airtime_success() -> void:
	if lastTrick != Utils.Tricks.Airtime:
		lastTrick = Utils.Tricks.Airtime
		combo = 1
	elif comboTimer.time_left > 0:
		combo += 1
	comboTimer.start()
	_display_text("AIRTIME")

func _display_text(text: String):
	var label = _create_label()
	label.text = text + " " + str(combo) + "X!!!"
	label.modulate.a = 1.0
	label.visible = true

	var start_pos = Vector2(label.position.x, get_viewport_rect().size.y + ENTER_OFFSET)
	var end_pos = Vector2(label.position.x, get_viewport_rect().size.y - RISE_DISTANCE)
	end_pos += OFFSETS[offsetIndex]
	offsetIndex = (offsetIndex + 1) % 3

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


func _on_same_combo_timeout() -> void:
	combo = 1
