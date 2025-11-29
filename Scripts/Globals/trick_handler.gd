extends Node

enum Tricks { Airtime, ReverseAirtime, Turn, Flip, None }

const TrickStats = {
	Tricks.Airtime: {
		"name": "AIRTIME",
		"score": 50,
		"colour": Color.GREEN,
	},
	Tricks.ReverseAirtime: {
		"name": "REVERSE AIRTIME",
		"score": 150,
		"colour": Color.ORANGE,
	},
	Tricks.Flip: {
		"name": "FLIP",
		"score": 100,
		"colour": Color.BLUE,
	}
}

func get_trick_info(trick : Tricks) -> Dictionary:
	return TrickStats[trick]

func get_combo_damage(trick: Tricks, combo : int) -> float:
	var score = TrickStats[trick].score
	return (score * combo) / 100
