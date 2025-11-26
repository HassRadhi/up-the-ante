extends Node

# ENUMS
enum Tricks { Airtime, Turn, None }

# FUNCTIONS
func sleep(sec):
	await get_tree().create_timer(sec).timeout
