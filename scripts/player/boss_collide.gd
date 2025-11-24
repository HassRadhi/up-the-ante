extends CollisionShape2D

var playerTouchingBoss = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if playerTouchingBoss:
		SignalBus.player_hit.emit()
		playerTouchingBoss = false

func _on_boss_hurtbox_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	playerTouchingBoss = true

func _on_boss_hurtbox_body_shape_exited(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	playerTouchingBoss = false
