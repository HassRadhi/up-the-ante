extends VehicleBody3D

func _physics_process(_delta):
	steering = Input.get_axis("Steer Right", "Steer Left") * 0.4
	engine_force = Input.get_axis("Reverse", "Accelerate") * 100
