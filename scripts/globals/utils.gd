extends Node

# ENUMS
enum Tricks { Airtime, ReverseAirtime, Turn, Flip, None }

# FUNCTIONS
func sleep(sec):
	await get_tree().create_timer(sec).timeout
