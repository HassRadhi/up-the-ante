extends Node

func _process(_delta):
	SignalBus.set_camera_left_limit.emit(get_parent().global_position.x)
