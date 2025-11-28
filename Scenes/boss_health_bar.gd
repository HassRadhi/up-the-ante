extends Node2D

signal damage_boss
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage_boss.connect(_reduce_health)

func _reduce_health(damage : float):
	$ProgressBar.value -= damage
