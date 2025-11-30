extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var style := StyleBoxFlat.new()
	style.bg_color = Color(0.565, 0.434, 0.061, 1.0)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	style.corner_detail = 6

	add_theme_stylebox_override("panel", style)
