extends CharacterBody2D

signal airtime_success

const SPEED = 300.0
const JUMP_VELOCITY = -150.0
var speedMult = 1.0

@onready var stunTimer = $Stun
@onready var sprite = $AntSprite
@onready var boostTimer = $TurnBoost
var isStunned = false
var isGrounded = false
var isOnFloor = false

# Anim States
var facingRight = true
var jumping = false
var landing = false
var airtiming = false
var turning = false

func _ready():
	SignalBus.stun_player.connect(_on_stun)
	
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
			turning = false
		elif !isGrounded:
			isGrounded = true
			sprite.play("Landing")
			landing = true
			airtiming = false
	
	if airtiming || turning:
		move_and_slide()
		return
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		var oldFacing = facingRight
		facingRight = direction > 0
		
		if oldFacing != facingRight:
			_attempt_to_turn()
			
		velocity.x = direction * SPEED * speedMult
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_stun():
	isStunned = true
	stunTimer.start()
	sprite.stop()

func _on_stun_timeout() -> void:
	isStunned = false
	
func update_animation() -> void:
	if (!turning):
		sprite.flip_h = !facingRight
	
	if !isOnFloor:
		turning = false
		# If in the air
		if sprite.animation != "AirTime" && !jumping:
			airtiming = true
			sprite.play("AirTime")
		if airtiming && !Input.is_action_pressed("jump"):
			sprite.play("Fall")
			airtiming = false

	else:
		# On the ground
		if landing || turning:
			return
		if !velocity.x:
			sprite.play("Idle")
		elif sprite.animation != "Skating":
			sprite.play("Skating")

func _on_ant_sprite_animation_finished() -> void:
	match sprite.animation:
		"InitialJump":
			jumping = false
		"Landing":
			landing = false
		"Turning":
			# Successful Turn
			turning = false
			speedMult = 1.5
			boostTimer.start()

func _on_ant_sprite_animation_looped() -> void:
	match sprite.animation:
		"AirTime":
			airtime_success.emit()

func _attempt_to_turn() -> void:
	if isOnFloor && sprite.animation != "InitialJump":
		if sprite.animation == "Turning":
			sprite.stop()
		sprite.play("Turning")
		turning = true
		landing = false

func _on_turn_boost_timeout() -> void:
	speedMult = lerp(speedMult, 1.0, 1)

func _on_boss_hurtbox_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	$CollisionShape2D._player_entered_boss_hurtbox()
	
func _on_boss_hurtbox_body_shape_exited(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	$CollisionShape2D._player_exited_boss_hurtbox()
