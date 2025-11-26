extends Node
class_name StateMachine

@export var initState : State

var curState : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(_on_transition)
	
	if initState:
		initState.enter()
		curState = initState

func _process(delta):
	if curState:
		curState.update(delta)

func _physics_process(delta):
	if curState:
		curState.physics_update(delta)

func _on_transition(state, newStateName):
	if state != curState:
		return
	
	var newState = states.get(newStateName.to_lower())
	if !newState:
		return
	
	
