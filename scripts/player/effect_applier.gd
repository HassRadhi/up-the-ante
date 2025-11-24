extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_hit.connect(apply_hit_affect)

func apply_hit_affect() -> void:
	var antBody = get_parent()
	var curVelocity = abs(antBody.velocity.x)
	SignalBus.stun_player.emit()
	antBody.velocity = Vector2(750 + curVelocity,-250)
