extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D
var speed = 800
var direction = Vector2.ZERO

func shoot():
	sprite.play("grape")

func _physics_process(_delta):
	if direction != Vector2.ZERO:
		velocity = direction * speed
		move_and_slide()
		
func _on_hitbox_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		SignalBus.player_hit.emit()
