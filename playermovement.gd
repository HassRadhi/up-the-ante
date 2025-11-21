extends CharacterBody3D

signal hit

# How fast the player moves in meters per second
@export var speed = 30
# The downward acceleration while in the air, in meters per second squared.
@export var fall_acceleration = 75
var target_velocity = Vector3.ZERO
@onready var _camera_pivot: Node3D = $CameraPivot
@onready var _camera: Camera3D = $CameraPivot/SpringArm3D/Camera3D



@export_range(0.0, 1.0) var mouse_sensitivity = 0.01
@export var tilt_limit = deg_to_rad(75)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_camera.current = true

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		print("Mouse moved: ", event.relative)
		_camera_pivot.rotation.x -= event.relative.y * mouse_sensitivity
		# Prevent the camera from rotating too far up or down.
		_camera_pivot.rotation.x = clampf(_camera_pivot.rotation.x, -tilt_limit, tilt_limit)
		_camera_pivot.rotation.y += -event.relative.x * mouse_sensitivity

func _physics_process(_delta):
	# We create a local variable to store the input direction
	var direction = Vector3.ZERO

	# We check for each move input and update the direction accordingly
	if Input.is_action_pressed("Steer Left"):
		direction.x = direction.x + 1
	if Input.is_action_pressed("Steer Right"):
		direction.x = direction.x - 1
	if Input.is_action_pressed("Accelerate"):
		direction.z = direction.z + 1
	if Input.is_action_pressed("Reverse"):
		direction.z = direction.z - 1

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
