extends CharacterBody3D

signal hit

# How fast the player moves in meters per second
@export var speed = 30
# The downward acceleration while in the air, in meters per second squared.
@export var fall_acceleration = 75

var target_velocity = Vector3.ZERO


func _physics_process(delta):
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

	# Vertical Velocity
	if not is_on_floor(): # If in the air, fall towards the floor. Literally gravity
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Jumping.

	# Moving the Character
	velocity = target_velocity
	move_and_slide()

# And this function at the bottom.
func die():
	hit.emit()
	queue_free()

func _on_mob_detector_body_entered(_body):
	die()
