extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

@onready var stunTimer = $Stun
@onready var animation = $AntSprite
var isStunned = false
var isGrounded = false
var landing_locked = false


func _ready():
	SignalBus.stun_player.connect(on_stun)
	
func _physics_process(delta: float) -> void:
	if not landing_locked:
		update_animation(is_on_floor())
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if isStunned:
		move_and_slide()
		return
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animation.play("InitalJump")
		print("oh yea baby")
		
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
		
	if is_on_floor():
		# Handle hitting ground
		if !isGrounded:
			isGrounded = true
			play_landing()
	elif isGrounded:
		isGrounded = false
	


func on_stun():
	isStunned = true
	stunTimer.start()

func _on_stun_timeout() -> void:
	isStunned = false
	
func update_animation(on_floor: bool) -> void:
	if not on_floor:
		# If in the air
		if animation.animation != "AirTime":
			animation.play("AirTime")
			print("Airtime")
	else:
		# On the ground
		if animation.animation != "Skating":
			animation.play("Skating")
			print("Skating")
		
func play_landing() -> void:
	animation.stop()
	landing_locked = true
	animation.play("Landing")
	print("This is getting a bit insane")


func _on_ant_sprite_animation_finished() -> void:
	if animation.animation == "Landing":
		print("Captin are we gettin this")
		landing_locked = false
		update_animation(is_on_floor())
	
