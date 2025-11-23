extends RigidBody3D


@onready var ant: Node3D = $ant         
@onready var skateboard: Node3D = $ant/skateboard 
@onready var ground_ray: RayCast3D = $ant/"Ground Detector"

@export var BALL_RADIUS: float = 1.5
@export var ROLLING_FORCE: float = 40.0       


func _ready() -> void:
	# These nodes no longer inherit Ball's transform
	ant.top_level = true
	ground_ray.top_level = true


func _physics_process(delta: float) -> void:
	var center: Vector3 = global_transform.origin
	var bottom_pos: Vector3 = center + Vector3.DOWN * BALL_RADIUS

	# Keep the ant at the bottom, upright in world space
	var ant_xform: Transform3D = ant.global_transform
	ant_xform.origin = bottom_pos          # position
	ant_xform.basis = Basis()              # identity -> upright (no tilt)
	ant.global_transform = ant_xform

	# Move the ray so it always checks under the ball
	ground_ray.global_transform.origin = center



	if Input.is_action_pressed("Accelerate"):
		angular_velocity.x += ROLLING_FORCE * delta
	elif Input.is_action_pressed("Reverse"):
		angular_velocity.x -= ROLLING_FORCE * delta

	if Input.is_action_pressed("Steer Left"):
		angular_velocity.z -= ROLLING_FORCE * delta
	elif Input.is_action_pressed("Steer Right"):
		angular_velocity.z += ROLLING_FORCE * delta
