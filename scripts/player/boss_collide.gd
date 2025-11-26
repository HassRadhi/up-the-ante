extends CollisionShape2D

var playerTouchingBoss = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if playerTouchingBoss:
		SignalBus.player_hit.emit()
		playerTouchingBoss = false

func _player_entered_boss_hurtbox() -> void:
	playerTouchingBoss = true

func _player_exited_boss_hurtbox() -> void:
	playerTouchingBoss = false
