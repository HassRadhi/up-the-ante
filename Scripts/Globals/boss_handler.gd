extends Node

var boss : CharacterBody2D
var sprite : AnimatedSprite2D
var facingRight = true

func _ready():
	SignalBus.swap_boss_direction.connect(_toggle_direction)

func set_current_boss(newBoss : CharacterBody2D):
	boss = newBoss
	for child in boss.get_children():
		if child is AnimatedSprite2D:
			sprite = child
			print("found sprite")

func get_current_boss() -> CharacterBody2D:
	return boss

func _process(_delta):
	if !boss:
		return
	
	if facingRight:
		SignalBus.set_camera_left_limit.emit(boss.global_position.x)
	else:
		SignalBus.set_camera_right_limit.emit(boss.global_position.x + sprite.size.x)
	
func _toggle_direction():
	facingRight = !facingRight
