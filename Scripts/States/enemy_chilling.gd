extends State
class_name EnemyChilling

@export var enemy : CharacterBody2D
var player : CharacterBody2D

var initialPosition
var isGrounded = false

func enter():
	player = get_tree().get_first_node_in_group("Player")
	initialPosition = player.global_position
	

func physics_update(delta: float):
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity() * delta * 5
		enemy.move_and_slide()
		
	if enemy.is_on_floor() and !isGrounded:
		isGrounded = true
		enemy.get_node("Stomp").display_fart()
		
	if Vector2(player.global_position - initialPosition).length() > 10:
		transitioned.emit(self, "EnemyStomp")
