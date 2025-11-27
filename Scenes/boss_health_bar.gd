extends Node2D

signal damage_boss
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage_boss.connect(_reduce_health)
	_reduce_health(10)

func _reduce_health(damage : float):
	$ProgressBar.value += damage
