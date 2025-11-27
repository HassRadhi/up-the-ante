extends Node

var player : CharacterBody2D = null

func register_player(p : CharacterBody2D):
	player = p

func get_player() -> CharacterBody2D:
	return player
