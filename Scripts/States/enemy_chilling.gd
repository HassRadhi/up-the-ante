extends State
class_name EnemyChilling

@export var enemy : CharacterBody2D
var player : CharacterBody2D

var initialPosition

func enter():
	if not enemy:
		return
	player = Locator.get_player()
	initialPosition = player.global_position
	

func physics_update(delta: float):
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity() * delta * 5
		enemy.move_and_slide()
		
	if Vector2(player.global_position - initialPosition).length() > 10:
		transitioned.emit(self, "EnemyStomp")
