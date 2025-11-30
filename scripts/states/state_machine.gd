extends Node
class_name StateMachine

@export var initState : State

var curState : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name] = child
			child.transitioned.connect(on_transition)
	
	if initState:
		initState.enter()
		curState = initState

func _process(delta):
	if curState:
		curState.update(delta)

func _physics_process(delta):
	if curState:
		curState.physics_update(delta)

func on_transition(state : State, newStateName : String):
	if state != curState:
		return
	
	var newState = states.get(newStateName)
	if !newState:
		return
	
	if curState:
		curState.exit()
	
	newState.enter()
	
	curState = newState
