extends Label

func _ready():
	modulate.a = 0
	fade_in_out()

func fade_in_out():
	var tween = create_tween()
	tween.set_loops()  # infinite loop

	tween.tween_property(self, "modulate:a", 1, 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "modulate:a", 0, 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
