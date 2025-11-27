extends CanvasLayer

func change_scene(target: String) -> void:
	$AnimationPlayer.play("dissolve")
	await $AnimationPlayer.animation_finished
	get_tree().change_scene_to_file(target)
	$AnimationPlayer.play_backwards("dissolve")

# Intended use
func on_main_menu() -> void:
	SceneTransition.change_scene('res://Scenes/frog_arena')
