extends Label

@onready var button = $Button

func _ready():
	pivot_offset = size * 0.5
	button.focus_mode = Control.FOCUS_NONE
	float_up_down()

func float_up_down():
	var tween = create_tween()
	tween.set_loops()  # infinite loop

	var start_pos = position
	var up_pos = start_pos + Vector2(0, -10)  # how far up

	tween.tween_property(self, "position", up_pos, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", start_pos, 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func enable():
	button.disable = false

func disable():
	button.disabled = true

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/spawn.tscn")
	BossHandler.restart()

func _on_button_mouse_entered() -> void:
	scale *= 1.2

func _on_button_mouse_exited() -> void:
	scale /= 1.2
