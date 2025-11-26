extends Node2D

@onready var iframes = get_parent().get_node("Immunity")
@export var body : CharacterBody2D

var immune = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_hit.connect(_apply_hit_affect)

func _apply_hit_affect() -> void:
	if !immune:
		var curVelocity = abs(body.velocity.x)
		SignalBus.stun_player.emit()
		body.velocity = Vector2(750 + curVelocity,-250)
	
	else:
		iframes.start()
		immune = true

func _on_immunity_timeout() -> void:
	immune = false
