extends Sprite2D

func _on_fart_cd_timeout() -> void:
	self.visible = false

func _on_enemy_stomp_landed() -> void:
	visible = true
	$FartCD.start()
