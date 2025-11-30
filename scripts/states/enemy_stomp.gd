extends State
class_name EnemyStomp

signal landed

@export var enemy : CharacterBody2D
@onready var animTimer = $JumpAnim
@onready var groundRay = $RayCast2D
@onready var attackIndicator = $RayCast2D/AttackIndicator

const LEAP_VECTOR = Vector2(100, -3000)

var isGrounded = false
var firstLand = true

var timer := Timer.new()
var jumping = false
var leapCount = 0
var onPlayer = true

func _ready():
	add_child(timer)
	timer.wait_time = 4.0
	timer.timeout.connect(_on_timer_timeout)

func enter():
	BossHandler.sprite.play("TurnAway")
	leapCount = 0
	_leap()
	timer.start()

func exit():
	timer.stop()

func physics_update(delta: float):
	groundRay.global_position = enemy.global_position
	if jumping:
		return
		
	if enemy.velocity.y > 0 and !onPlayer:
		var player = Locator.get_player()
		if BossHandler.facingRight and enemy.global_position.x < player.global_position.x:
			enemy.global_position.x = Locator.get_player().global_position.x - 300
		elif !BossHandler.facingRight and enemy.global_position.x > player.global_position.x:
			enemy.global_position.x = Locator.get_player().global_position.x + 300
		
		onPlayer = true
	
	if not enemy.is_on_floor():
		enemy.velocity += enemy.get_gravity() * delta * 5
	
	if enemy.velocity.y > 0 and groundRay.is_colliding():
		var hitPoint = groundRay.get_collision_point()
		var origin = groundRay.global_position

		var dist = origin.distance_to(hitPoint)
		
		attackIndicator.position = Vector2.ZERO
		attackIndicator.scale.y = dist

		attackIndicator.visible = true
		
	else:
		attackIndicator.visible = false
	
	if enemy.is_on_floor():
		enemy.velocity.x = 0
		# Handle hitting ground
		if !isGrounded:
			isGrounded = true
			SignalBus.shake_camera.emit()
			landed.emit()
			BossHandler.sprite.play("FaceTurn")
			BossHandler.end_boss_attack.emit()
			
			if leapCount > 2 and BossHandler.health <= 75.0:
				if randi_range(0,1) == 1:
					transitioned.emit(self, "EnemyGrapeAttack")
	
	elif isGrounded:
		isGrounded = false
	
	enemy.move_and_slide()

func _on_timer_timeout() -> void:
	_leap()
	
func _leap():
	
	if enemy.is_on_floor():
		BossHandler.start_boss_attack.emit()
		enemy.velocity = LEAP_VECTOR if BossHandler.facingRight else LEAP_VECTOR * Vector2(-1,1)
		BossHandler.sprite.play("InitialJump")
		jumping = true
		animTimer.start()
		leapCount += 1
		onPlayer = false

func _on_jump_anim_timeout() -> void:
	enemy.move_and_slide()
	jumping = false
