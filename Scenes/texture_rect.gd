extends TextureRect
func play_transition():
	var tween = create_tween()
	tween.tween_method(
		func(v): mat.set_shader_parameter("progress", v),
		0.0, 1.0, 1.0
	)
