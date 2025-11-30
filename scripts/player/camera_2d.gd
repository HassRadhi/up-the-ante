extends Camera2D
var period:float = 0.3

func _ready():
	SignalBus.shake_camera.connect(_camera_shake)
	_move_left_camera_limit(Utils.get_map_left_bound())
	_move_right_camera_limit(Utils.get_map_right_bound())
	
func _move_left_camera_limit(limit):
	limit_left = int(limit)

func _move_right_camera_limit(limit):
	limit_right = int(limit)

func _camera_shake(mag = 100.0):
	var initial_transform:Transform2D = self.transform # Store the full initial transform of the camera
	var elapsed_time:float = 0.0
	while elapsed_time < period:
		var off = Vector2(
		randf_range(-mag, mag),
		randf_range(-mag, mag),
		)
		self.transform.origin = initial_transform.origin + off
		elapsed_time += get_process_delta_time()
		await get_tree().process_frame
		self.transform = initial_transform # Reset back to the original transform
