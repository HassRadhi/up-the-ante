extends CharacterBody3D

signal hit

# Movement velocity definitions
@export var speed: float = 30.0
@export var fall_acceleration: float = 75.0
var target_velocity: Vector3 = Vector3.ZERO

# References into the player scene
@onready var _camera_pivot: Node3D = $CameraPivot
@onready var _pivot: Node3D = $Pivot


func _physics_process(delta: float) -> void:
	# Get input: x = left/right, y = forward/back
	var input_dir: Vector2 = Input.get_vector("Steer Left", "Steer Right", "Accelerate", "Reverse")

	# Direction relative to camera
	var direction: Vector3 = Vector3.ZERO
	if input_dir != Vector2.ZERO:
		direction = (_camera_pivot.transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()

		# Rotate the visual pivot to face movement direction (smooth)
		var flat_dir: Vector3 = direction
		flat_dir.y = 0.0
		if flat_dir.length() > 0.001:
			var target_angle: float = atan2(flat_dir.x, -flat_dir.z)  # -Z = forward
			var current_angle: float = _pivot.rotation.y
			var turn_speed: float = 2.0  # increase to turn faster
			_pivot.rotation.y = lerp_angle(current_angle, target_angle, turn_speed * delta)

	# Ground velocity
	if direction != Vector3.ZERO:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)
		velocity.z = move_toward(velocity.z, 0.0, speed)

	# (Optional) gravity – only if you want it
	if not is_on_floor():
		velocity.y -= fall_acceleration * delta
	else:
		velocity.y = 0.0

	move_and_slide()


# Death logic
func die() -> void:
	hit.emit()
	queue_free()


func _on_mob_detector_body_entered(_body: Node) -> void:
	die()
