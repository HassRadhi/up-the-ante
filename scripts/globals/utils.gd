extends Node

# ENUMS

# FUNCTIONS
func sleep(sec):
	await get_tree().create_timer(sec).timeout
