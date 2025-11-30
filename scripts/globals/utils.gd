extends Node

const Scenes = {
	"Spawn": {
		"leftBound": -500,
		"rightBound": 500,
	},
	"FrogArena": {
		"leftBound": -500,
		"rightBound": 10400,
	},
}
	
# FUNCTION
func sleep(sec):
	await get_tree().create_timer(sec).timeout

func get_map_left_bound() -> float:
	return Scenes[get_tree().current_scene.name].leftBound

func get_map_right_bound() -> float:
	return Scenes[get_tree().current_scene.name].rightBound
