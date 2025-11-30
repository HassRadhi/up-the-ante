extends Node2D

@onready var frogSprite = get_parent().get_node("FrogSprite")
@onready var sprite = $Sprite
@onready var fartTimer = $FartCD
@onready var collider = $Area2D/CollisionShape2D

func display_fart():
	sprite.visible = true
	sprite.play("Smoke")
	SignalBus.shake_camera.emit(2000)
	fartTimer.start()

func _on_fart_cd_timeout() -> void:
	sprite.visible = false
	collider.disabled = true

func _on_enemy_stomp_landed() -> void:
	sprite.visible = true
	sprite.play("Smoke")
	collider.disabled = false
	fartTimer.start()
