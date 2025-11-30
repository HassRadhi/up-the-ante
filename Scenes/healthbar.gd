extends Node2D

var hearts = Array()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SignalBus.player_hit.connect(_remove_health)
	for child in get_children():
		hearts.append(child)
		child.visible = true

func _remove_health():
	hearts.pop_front().queue_free()
	if hearts.is_empty():
		get_tree().change_scene_to_file("res://Scenes/death_screen.tscn")
