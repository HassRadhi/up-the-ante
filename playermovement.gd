extends CharacterBody3D

signal hit

# Movement velocity definitions
@export var speed = 30
@export var fall_acceleration = 75
var target_velocity = Vector3.ZERO

# Locates camera nodes to access values for transformation
@onready var _camera_pivot: Node3D = $CameraPivot
@onready var _camera: Camera3D = $CameraPivot/SpringArm3D/Camera3D


# This is the actual camera movement limits tilting and looking
@export_range(0.0, 1.0) var mouse_sensitivity = 0.001
@export var vertical_limit = deg_to_rad(30) # Vertical limit

# This makes it so you cant fully lo
# Horizontal look limits
@export var horizontal_limit := deg_to_rad(10)   # how far you can look left/right when not steering
@export var extra_hor_limit := deg_to_rad(20)  # extra allowed when steering hard
var steering_input: float = 0.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_camera.current = true

# No idea how this code works, used tutorial code https://docs.godotengine.org/en/latest/tutorials/3d/spring_arm.html
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Only affects vertical limits
		_camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		# Prevent the camera from rotating too far up or down.
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -vertical_limit, vertical_limit)
		
		# Horizontal limits SHIZZ DOESNT WORK GAHH
		_camera_pivot.rotation.y += -event.relative.x * mouse_sensitivity
		# NOTE: When steering input < 0 its going right visa versa
		if steering_input > 0.0: # How far we can look left
			horizontal_limit += steering_input * extra_hor_limit # sorry for ass naming convention
		if steering_input < 0.0:
			# Steering input is negative 
			horizontal_limit += -steering_input * extra_hor_limit 
		_camera_pivot.rotation.y = clampf(_camera_pivot.rotation.y, -horizontal_limit, horizontal_limit)


func _physics_process(_delta):
	# We create a local variable to store the input direction
	var direction = Vector3.ZERO
	steering_input = 0.0 # every frame
	# We check for each move input and update the direction accordingly
	if Input.is_action_pressed("Steer Left"):
		direction.x -= 1
		steering_input += 1.0
	if Input.is_action_pressed("Steer Right"):
		direction.x += 1
		steering_input -= 1.0
	if Input.is_action_pressed("Accelerate"):
		direction.z -= 1
	if Input.is_action_pressed("Reverse"):
		direction.z += 1

	# Prevent diagonal moving fast af
	if direction != Vector3.ZERO:
		direction = direction.normalized()
		# Setting the basis property will affect the rotation of the node.
		$Pivot.basis = Basis.looking_at(direction)

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed


	# Moving the Character
	velocity = target_velocity
	move_and_slide()

# And this function at the bottom.
func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(_body):
	die()
