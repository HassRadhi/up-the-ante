extends CharacterBody2D

signal airtime_success
signal flip_success

const SPEED = 300.0
const JUMP_VELOCITY = -150.0
const ACCELERATION = 8
const FRICTION = 1
const DRAG = 0.95
const FLIP_SPEED = 7
const GROUND_SPEED_THRESHOLD = 3000.0

var speedMult = 1.0
var last_floor_normal = null


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
	Locator.register_player(self)
	
func _physics_process(delta: float) -> void:
	var wasOnFloor = isOnFloor
	
	var new_floor = false

	if isStunned:
		if not is_on_floor():
			velocity += get_gravity() * delta
			isGrounded = false
		move_and_slide()
		return
	
	if is_on_floor():
		var normal = get_floor_normal()
		var angle_change = 0.0

		if last_floor_normal != null:
			angle_change = rad_to_deg(acos(clamp(last_floor_normal.dot(normal), -1, 1)))

		var crest_launch = (
			wasOnFloor
			and velocity.y < 400.0
			and angle_change > 45.0
		)

		if !crest_launch:
			new_floor = true

	isOnFloor = new_floor

	
	# store valid normal while grounded
	if isOnFloor:
		jumping = false
		last_floor_normal = get_floor_normal()

	# momentum projection after leaving ramp
	if wasOnFloor and !isOnFloor and !jumping:
		var n = last_floor_normal
		var t = Vector2(n.y, -n.x).normalized()

		# ensure tangent matches movement direction
		if velocity.x != 0:
			var dir = Vector2.RIGHT if velocity.x > 0 else Vector2.LEFT
			if t.dot(dir) < 0:
				t = -t

		# project speed onto tangent
		var angle = rad_to_deg(acos(last_floor_normal.dot(Vector2.UP)))
		var ramp_factor = clamp(angle / 40.0, 0.0, 1.0)
		var horizontal_speed = abs(velocity.x)
		velocity = t * (horizontal_speed * ramp_factor + horizontal_speed * (1.0 - ramp_factor) * 0.5)
		velocity.y *= 0.5
	
	if not isOnFloor:
		velocity += get_gravity() * delta
		isGrounded = false

	if isStunned:
		move_and_slide()
		return
	
	update_animation()
	# Handle floor actions
	if isOnFloor:
		if get_slide_collision_count() > 0: 
			var tween = create_tween() 
			var floorangle = atan2(get_last_slide_collision().get_normal().x, -get_last_slide_collision().get_normal().y) 
			if (abs(floorangle) < abs(sprite.rotation) and sprite.rotation < 0): 
				tween.tween_property(sprite, "rotation", floorangle, 0.4) 
			else: 
				tween.tween_property(sprite, "rotation", floorangle, 0.2)
				
		var normal = get_floor_normal()
		var tangent = Vector2(normal.y, -normal.x).normalized()
		
		if tangent.dot(Vector2(0, 1)) < 0:
			tangent = -tangent
		# Apply slide force
		var angle_deg = rad_to_deg(acos(normal.dot(Vector2.UP)))
		if angle_deg > 5:
			velocity += tangent * 2000 * delta
		
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
	
	if airtiming or turning:
		move_and_slide()
		return
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if !isOnFloor:
		velocity.x = lerp(velocity.x, 0.0, delta * DRAG)
	elif direction != 0:
		velocity.x += direction * ACCELERATION * speedMult
	else:
	# friction
		velocity.x = lerp(velocity.x, 0.0, delta * FRICTION)

	if direction:
		var oldFacing = facingRight
		facingRight = direction > 0
		
		if oldFacing != facingRight:
			_attempt_to_turn()
		
		if !isOnFloor:
			if abs(sprite.rotation + direction * FLIP_SPEED * delta) >= deg_to_rad(360):
				flip_success.emit()
			sprite.rotation = fmod(sprite.rotation + direction * FLIP_SPEED * delta, deg_to_rad(360))

	move_and_slide()

func _on_stun(duration : float = 0.5):
	isStunned = true
	stunTimer.wait_time = duration
	stunTimer.start()
	sprite.stop()

func _on_stun_timeout() -> void:
	isStunned = false
	
func update_animation() -> void:
	if (!turning):
		sprite.flip_h = !facingRight
	
	if velocity.y < -5 or !isOnFloor:
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
		if abs(velocity.x) < 20:
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
