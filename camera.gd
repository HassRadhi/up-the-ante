extends Node3D

# Camera look settings
@export_range(0.0, 1.0) var mouse_sensitivity: float = 0.001
@export var vertical_limit: float = deg_to_rad(30.0)  # up/down clamp

# Node refs
#@onready var _spring_arm: SpringArm3D = $SpringArm3D
@onready var _camera: Camera3D = $SpringArm3D/Camera3D
#@onready var _player: CharacterBody3D = get_parent() as CharacterBody3D
@onready var _pivot: Node3D = $"../Pivot"


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	_camera.current = true


# Mouse only controls vertical tilt now
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clampf(rotation.x, -vertical_limit, vertical_limit)


# Camera yaw follows the player's facing (Pivot)
func _physics_process(delta: float) -> void:
	if not is_instance_valid(_pivot):
		return

	var cam_turn_speed: float = 5.0  # higher = camera snaps behind player faster
	var target_cam_yaw: float = _pivot.rotation.y
	var current_cam_yaw: float = rotation.y

	rotation.y = lerp_angle(current_cam_yaw, target_cam_yaw, cam_turn_speed * delta)
