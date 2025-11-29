extends Node

# ENUMS

	
# FUNCTION
func sleep(sec):
	await get_tree().create_timer(sec).timeout
