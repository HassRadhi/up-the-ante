extends RigidBody3D

var sphere_offset = Vector3.DOWN
var acceleration = 35.0
var steering = 19.0
var turn_speed = 4.0
var turn_stop_limit = 0.75
var body_tilt = 35

var speed_input = 0
var turn_input = 0

@onready var ant_mesh = $Character
@onready var ground_ray = $Character/RayCast3D
#@onready var right_wheel = $Character/Skateboard/FrontRight
#@onready var left_wheel = $Character/Skateboard/FrontLeft

#func _ready():
#	ground_ray.add_exception(self)
	
func _physics_process(_delta):
	ant_mesh.position = position + sphere_offset
	if ground_ray.is_colliding():
		apply_central_force(-ant_mesh.global_transform.basis.z * speed_input)
	
func _process(delta):
	if not ground_ray.is_colliding():
		return
	speed_input = Input.get_axis("brake", "accelerate") * acceleration
	turn_input = Input.get_axis("steer_right", "steer_left") * deg_to_rad(steering)
	#right_wheel.rotation.y = turn_input
	#left_wheel.rotation.y = turn_input
	
	if linear_velocity.length() > turn_stop_limit:
		var new_basis = ant_mesh.global_transform.basis.rotated(ant_mesh.global_transform.basis.y, turn_input)
		ant_mesh.global_transform.basis = ant_mesh.global_transform.basis.slerp(new_basis, turn_speed * delta)
		ant_mesh.global_transform = ant_mesh.global_transform.orthonormalized()
		var t = -turn_input * linear_velocity.length() / body_tilt
		ant_mesh.rotation.z = lerp(ant_mesh.rotation.z, t, 5.0 * delta)
		if ground_ray.is_colliding():
			var n = ground_ray.get_collision_normal()
			var xform = align_with_y(ant_mesh.global_transform, n)
			ant_mesh.global_transform = ant_mesh.global_transform.interpolate_with(xform, 10.0 * delta)

func align_with_y(xform, new_y):
	xform.basis.y = new_y
	xform.basis.x = -xform.basis.z.cross(new_y)
#	xform.basis = xform.basis.orthonormalized()
	return xform.orthonormalized()
