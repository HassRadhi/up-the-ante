extends Label

var messages = ["Bet you didn't ANTicipate\n that one", 
"I guess you were his ANTree", "BUGger luck next time", 
"Now on ASUS FROG Xbox Ally X"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = messages.pick_random()
