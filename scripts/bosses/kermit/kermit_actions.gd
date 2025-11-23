extends CharacterBody2D

const LEAP_VELOCITY_Y = -1000
const LEAP_VELOCITY_X = 100
var isGrounded = false
# Called when the node enters the scene tree for the first time.

# Moves camera with boss
func _process(_delta):
	SignalBus.set_camera_left_limit.emit(global_position.x)

func _physics_process(delta: float):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor():
		velocity.x = 0
		# Handle hitting ground
		if !isGrounded:
			isGrounded = true
			SignalBus.shake_camera.emit()
			$Stomp.visible = true
			$Stomp/FartCD.start()
			
	elif isGrounded:
		isGrounded = false
	
	move_and_slide()

func _on_jump_cd_timeout() -> void:
	if is_on_floor():
		velocity.y = LEAP_VELOCITY_Y
		velocity.x = LEAP_VELOCITY_X
	
	move_and_slide()
