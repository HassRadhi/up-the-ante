extends State
class_name EnemyStomp

signal landed

@export var enemy : CharacterBody2D

const LEAP_VECTOR = Vector2(100, -1000)

var isGrounded = false

var timer := Timer.new()

func _ready():
	add_child(timer)
	timer.wait_time = 3.0
	timer.timeout.connect(_on_timer_timeout)

func enter():
	timer.start()

func exit():
	timer.stop()

# Moves camera with boss
func update(_delta):
	SignalBus.set_camera_left_limit.emit(enemy.global_position.x)

func physics_update(delta: float):
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity() * delta
	
	if enemy.is_on_floor():
		enemy.velocity.x = 0
		# Handle hitting ground
		if !isGrounded:
			isGrounded = true
			SignalBus.shake_camera.emit()
			landed.emit()
			
	elif isGrounded:
		isGrounded = false
	
	enemy.move_and_slide()

func _on_timer_timeout() -> void:
	if enemy.is_on_floor():
		enemy.velocity = LEAP_VECTOR
	
	enemy.move_and_slide()
