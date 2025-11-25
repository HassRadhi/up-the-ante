extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -600.0

@onready var stunTimer = $Stun
@onready var sprite = $AntSprite
var isStunned = false
var isGrounded = false
var isOnFloor = false

# Anim States
var facingRight = true
var jumping = false
var landing = false
var airtiming = false

func _ready():
	SignalBus.stun_player.connect(on_stun)
	
func _physics_process(delta: float) -> void:
	isOnFloor = is_on_floor()
	
	# Add the gravity.
	if not isOnFloor:
		velocity += get_gravity() * delta
		isGrounded = false

	if isStunned:
		move_and_slide()
		return
	
	update_animation()
	# Handle floor actions
	if isOnFloor:
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
			sprite.play("InitialJump")
			jumping = true
		elif !isGrounded:
			isGrounded = true
			sprite.play("Landing")
			landing = true
			airtiming = false
	
	if airtiming:
		move_and_slide()
		return
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		if (direction < 0):
			facingRight = false
		else:
			facingRight = true
			
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func on_stun():
	isStunned = true
	stunTimer.start()
	sprite.stop()

func _on_stun_timeout() -> void:
	isStunned = false
	
func update_animation() -> void:
	sprite.flip_h = !facingRight
	
	if !isOnFloor:
		# If in the air
		if sprite.animation != "AirTime" && !jumping:
			airtiming = true
			sprite.play("AirTime")
		if airtiming && !Input.is_action_pressed("jump"):
			sprite.play("Fall")
			airtiming = false

	else:
		# On the ground
		if landing:
			return
		if !velocity.x:
			sprite.play("Idle")
		elif sprite.animation != "Skating":
			sprite.play("Skating")


func _on_ant_sprite_animation_finished() -> void:
	match sprite.animation:
		"InitialJump":
			jumping = false
			print("jump ended")
		"Landing":
			landing = false
