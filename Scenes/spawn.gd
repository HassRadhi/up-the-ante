extends Node2D

@onready var ant = $Ant
@onready var play = $CanvasLayer/Play

func _process(_delta):
	if Input.is_action_just_pressed("jump"):
		play.visible = false
		ant.disabled = false
