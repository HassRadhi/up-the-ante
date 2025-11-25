extends Camera2D
var period:float = 0.3

func _ready():
	SignalBus.shake_camera.connect(_camera_shake)
	SignalBus.set_camera_left_limit.connect(_move_camera_limit)
	
func _move_camera_limit(limit):
	limit_left = limit

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
