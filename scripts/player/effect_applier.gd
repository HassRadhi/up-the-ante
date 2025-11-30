extends Node2D

@onready var iframes = get_parent().get_node("Immunity")
@export var body : CharacterBody2D

const LAUNCH_VELOCITY = Vector2(1200,-150)
var immune = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_hit.connect(_apply_hit_affect)

func _apply_hit_affect() -> void:
	if !immune:
		SignalBus.stun_player.emit()
		SignalBus.player_damaged.emit()
		body.velocity = LAUNCH_VELOCITY if BossHandler.facingRight else LAUNCH_VELOCITY * Vector2(-1,1)
		
		iframes.start()
		immune = true

func _on_immunity_timeout() -> void:
	immune = false
