extends Control

const ENTER_OFFSET = 50
const RISE_DISTANCE = 120
const ENTER_TIME = 0.25
const FADE_TIME = 0.8
const WINDUP_DISTANCE = 20
const HEALTHBAR_HIT_TIME = 0.2
const OFFSETS = [Vector2(0, -50), Vector2(-100, -50), Vector2(100, -50)]

@export var bossHealthbar : Node2D = null
@onready var comboTimer = $SameCombo
var lastTrick := TrickHandler.Tricks.None
var combo = 1
var lastLabel = null
var offsetIndex = 0
var hittingBoss = false
var trickQueue = Array()

func _process(_delta: float) -> void:
	if !trickQueue.is_empty() and !hittingBoss:
		var trick = trickQueue[0]
		_handle_trick(trick)
		trickQueue.erase(trick)

func _on_ant_airtime_success() -> void:
	var playerRotate = Locator.get_player().get_node("AntSprite").rotation
	var reverse = abs(playerRotate) < deg_to_rad(200) and abs(playerRotate) > deg_to_rad(160)
	if reverse:
		_handle_trick(TrickHandler.Tricks.ReverseAirtime)
	else:
		_handle_trick(TrickHandler.Tricks.Airtime)

func _on_ant_flip_success() -> void:
	_handle_trick(TrickHandler.Tricks.Flip)
	
func _handle_trick(trick : TrickHandler.Tricks):
	if hittingBoss:
		trickQueue.append(trick)
		
	_handle_combo(trick)
	_display_text(trick)
	lastTrick = trick

func _handle_combo(trick : TrickHandler.Tricks):
	if lastTrick != TrickHandler.Tricks.None:
		if lastTrick != trick:
			reset_trick()
			
		elif comboTimer.time_left > 0:
			combo += 1
	comboTimer.start()

func _display_text(trick : TrickHandler.Tricks):
	var trickInfo = TrickHandler.get_trick_info(trick)
	var text = trickInfo.name
	var colour = trickInfo.colour
	var label = _create_label()
	label.text = text + " " + str(combo) + "X!!!"
	label.modulate.a = 1.0
	label.visible = true
	label.modulate = colour

	var start_pos = Vector2(label.position.x, get_viewport_rect().size.y + ENTER_OFFSET)
	var end_pos = Vector2(label.position.x, get_viewport_rect().size.y - RISE_DISTANCE)
	end_pos += OFFSETS[offsetIndex]
	offsetIndex = (offsetIndex + 1) % 3

	label.position = start_pos

	var tween = create_tween()
	tween.tween_property(label, "position", end_pos, ENTER_TIME).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "modulate:a", 0.0, FADE_TIME).set_delay(1.1)
	await tween.finished
	label.queue_free() # ensures node is deleted after fade done

func _create_label() -> Label:
	var label = $PlaceholderLabel.duplicate()
	label.pivot_offset = label.size / 1.5
	label.set_rotation_degrees(randf_range(-15,15))
	add_child(label)
	lastLabel = label
	return label

func reset_trick():
	var curCombo = combo
	combo = 1
	
	if !is_instance_valid(lastLabel) || !bossHealthbar:
		hittingBoss = false
		return
	
	hittingBoss = true
	
	var tween = create_tween()
	var target = bossHealthbar.global_position - Vector2(230, 50)
	
	# GLOBAL bounce position (go up before falling)
	var bounce_pos := Vector2(lastLabel.global_position.x, lastLabel.global_position.y - 70)
	# 1. Bounce upward
	tween.tween_property(
		lastLabel,
		"global_position",
		bounce_pos,
		HEALTHBAR_HIT_TIME * 0.4
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	# 2. Fall downward into the boss healthbar
	tween.tween_property(
		lastLabel,
		"global_position",
		target,
		HEALTHBAR_HIT_TIME * 0.6
	).set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_IN)

	await tween.finished

	SignalBus.damage_boss.emit(TrickHandler.get_combo_damage(lastTrick, curCombo))
	hittingBoss = false
	
func _on_same_combo_timeout() -> void:
	reset_trick()
