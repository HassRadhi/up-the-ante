extends State
class_name EnemyGrapeAttack

@export var enemy : CharacterBody2D
@onready var eatTimer = $EatAnim
@onready var restTimer = $Rest
var player : CharacterBody2D
var grapes = Array()

func _ready():
	for child in get_children():
		if child is CharacterBody2D:
			grapes.append(child)

func enter():
	player = Locator.get_player()
	await get_tree().process_frame
	_eat()

func _eat():
	BossHandler.sprite.play("GrapeEat")
	await BossHandler.sprite.animation_finished
	eatTimer.start()
	

func _on_eat_anim_timeout() -> void:
	BossHandler.sprite.play("TurnAway")
	await BossHandler.sprite.animation_finished
	
	for i in range(3):
		BossHandler.sprite.play("GrapeShoot")
		await BossHandler.sprite.animation_finished
		
		var grape = grapes[i]
		grape.visible = true
		
		var offset = Vector2(200, 0) if BossHandler.facingRight else Vector2(-50, 0)
		grape.global_position = enemy.global_position + offset
		
		var dir = (player.global_position - grape.global_position).normalized()
		grape.direction = dir
		grape.look_at(player.global_position)
		grape.shoot()
	
	restTimer.start()

func _on_rest_timeout() -> void:
	if randi_range(0, 4) != 4:
		transitioned.emit(self, "EnemyStomp")
	else:
		_eat()
