extends Node2D

@onready var frogSprite = get_parent().get_node("FrogSprite")
@onready var sprite = $Sprite
@onready var fartTimer = $FartCD
@onready var collider = $Area2D/CollisionShape2D
@onready var sound = $AudioStreamPlayer

func display_fart():
	sprite.visible = true
	sprite.play("Smoke")
	SignalBus.shake_camera.emit(2000)
	fartTimer.start()
	sound.play()
	sound.volume_db -= 10.0

func _on_fart_cd_timeout() -> void:
	sprite.visible = false
	collider.disabled = true

func delay(seconds: float) -> void:
	var t := Timer.new()
	t.wait_time = seconds
	t.one_shot = true
	add_child(t)
	t.start()
	await t.timeout
	t.queue_free()

func _on_enemy_stomp_landed() -> void:
	await delay(0.1)
	sprite.visible = true
	sprite.play("Smoke")
	collider.disabled = false
	fartTimer.start()
	sound.play()
