extends Area2D

@onready var transition = $CanvasLayer

func _ready() -> void:
	transition.transition_finished.connect(_on_transition_finished)
	
func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		transition.play_transition() 

func _on_transition_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/frog_arena.tscn")
