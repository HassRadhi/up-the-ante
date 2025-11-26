extends Area2D

var playerTouchingSmoke = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if playerTouchingSmoke:
		SignalBus.player_hit.emit()
		playerTouchingSmoke = false

func _on_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	playerTouchingSmoke = true

func _on_body_shape_exited(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	playerTouchingSmoke = false
