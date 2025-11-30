extends State
class_name EnemyStomp

signal landed

@export var enemy : CharacterBody2D
@onready var animTimer = $JumpAnim

const LEAP_VECTOR = Vector2(100, -1500)

var isGrounded = false
var firstLand = true

var timer := Timer.new()
var jumping = false
var leapCount = 0

func _ready():
	add_child(timer)
	timer.wait_time = 4.0
	timer.timeout.connect(_on_timer_timeout)

func enter():
	leapCount = 0
	_leap()
	timer.start()

func exit():
	timer.stop()

func physics_update(delta: float):
	if jumping:
		return
		
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity() * delta * 5
	
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
	_leap()
	
func _leap():
	if enemy.is_on_floor():
		enemy.velocity = LEAP_VECTOR if BossHandler.facingRight else LEAP_VECTOR * Vector2(-1,1)
		BossHandler.sprite.play("InitialJump")
		jumping = true
		animTimer.start()
		leapCount += 1

func _on_jump_anim_timeout() -> void:
	enemy.move_and_slide()
	jumping = false
