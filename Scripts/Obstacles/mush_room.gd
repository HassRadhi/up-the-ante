extends AnimatableBody2D

func _on_area_2d_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body.is_in_group("Player"):
		var BOUNCE_VECTOR = Vector2(100, -450)
		if body.global_position.x > global_position.x:
			BOUNCE_VECTOR *= Vector2(-1, 1)
		SignalBus.stun_player.emit(0.1)
		body.velocity.x *= 0.33
		body.velocity += BOUNCE_VECTOR
		body.jumping = true
		body.isOnFloor = false
		body.isGrounded = false
