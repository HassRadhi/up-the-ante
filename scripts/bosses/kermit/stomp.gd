extends Node2D

@onready var sprite = $Sprite
@onready var fartTimer = $FartCD
@onready var collider = $Area2D/CollisionShape2D

func _on_fart_cd_timeout() -> void:
	sprite.visible = false
	collider.disabled = true

func _on_enemy_stomp_landed() -> void:
	sprite.visible = true
	sprite.play("Smoke")
	collider.disabled = false
	fartTimer.start()
