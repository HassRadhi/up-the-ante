extends Node2D

var hearts = Array()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is Sprite2D:
			hearts.append(child)
			child.visible = true
			
	SignalBus.player_damaged.connect(_remove_health)

func _remove_health():
	hearts.pop_front().visible = false
	
	if hearts.is_empty():
		get_tree().change_scene_to_file("res://Scenes/death_screen.tscn")
