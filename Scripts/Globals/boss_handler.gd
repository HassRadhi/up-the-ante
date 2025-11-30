extends Node

signal swap_boss_direction()
signal start_boss_attack()
signal end_boss_attack()

var boss : CharacterBody2D
var sprite : AnimatedSprite2D
var facingRight = true
var attacking = false
var health = 100.0

var phase2 = false

func _ready():
	swap_boss_direction.connect(_toggle_direction)
	start_boss_attack.connect(_attack_start)
	end_boss_attack.connect(_attack_end)
	SignalBus.damage_boss.connect(_reduce_health)

func set_current_boss(newBoss : CharacterBody2D):
	boss = newBoss
	for child in boss.get_children():
		if child is AnimatedSprite2D:
			sprite = child

func get_current_boss() -> CharacterBody2D:
	return boss

func _process(_delta):
	sprite.flip_h = !facingRight
	
	if !boss:
		return
	
	if attacking: 
		return
	
	if boss.global_position.x < Locator.get_player().global_position.x:
		facingRight = true
	else:
		facingRight = false
	
func _reduce_health(damage : float):
	health -= damage
	if health <= 100.0 / 2:
		phase2 = true
	
func _attack_start():
	attacking = true

func _attack_end():
	attacking = false

func _toggle_direction():
	facingRight = !facingRight
