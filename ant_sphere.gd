extends RigidBody3D
# REFRENCES
@onready var ant_mesh: Node3D = $ant      
@onready var board_mesh: Node3D = $ant/skateboard 
@onready var ground_ray: RayCast3D = $ant/"Ground Detector"

# Where to place the car mesh relative to the sphere
# The visual offset i think it just makes it so the model sits on the ball
var mesh_offset: Vector3 = Vector3(0, -0.5, 0)

# Definitions
var ACCELERATION = 35.0
# Turn amount, in degrees
var STEERING = 18.0
# How quickly the car turns
var TURN_SPEED = 4.0
# Below this speed, the car doesn't turn
var TURN_STOP_LIMIT = 0.75

# Variables for input values
var speed_input = 0
var turn_input = 0

# THis function makes it so the ant is positioned relative to ball
func _read() -> void:
		ant_mesh.position = mesh_offset
		board_mesh.position = mesh_offset
		
		
func _physics_process(delta: float) -> void:


	if ground_ray.is_colliding():
		var forward := -board_mesh.global_transform.basis.z
		apply_central_force(forward * speed_input)
		
	# Inputs to mvoe
	speed_input = Input.get_axis("Reverse", "Accelerate") * ACCELERATION
	turn_input = Input.get_axis("Steer Right", "Steer Left") * deg_to_rad(STEERING)
	
	# What makes us go forward
	if speed_input != 0.0:
		var forward = -ant_mesh.global_transform.basis.z
		apply_central_force(forward * speed_input)
		
	# Turning so we turn the car and rigid body
	if linear_velocity.length() > TURN_STOP_LIMIT and turn_input != 0.0:
		var amount = turn_input * TURN_SPEED * delta
		rotate_y(amount)
		ant_mesh.rotate_y(amount)
		board_mesh.rotate_y(amount)
		# Keep meshes at bottom of the ball in WORLD space
	var center: Vector3 = global_transform.origin
	var world_offset: Vector3 = mesh_offset  # e.g. Vector3.DOWN * radius

	board_mesh.global_transform.origin = center + world_offset
	ant_mesh.global_transform.origin = center + world_offset
