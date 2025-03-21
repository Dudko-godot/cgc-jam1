extends Node

@export var initial_state : State

var states : Dictionary = {}
var current_state : State


func _ready() -> void:
	for child in get_children():
		if child is State:
			child.process_mode = Node.PROCESS_MODE_DISABLED
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_child_transition)
			
	if initial_state:
		current_state = initial_state
		initial_state.enter()


func _process(delta : float) -> void:
	if current_state:
		current_state.update(delta)


func _physics_process(delta : float) -> void:
	if current_state:
		current_state.physics_update(delta)


func _on_child_transition(state : State, new_state_name : String) -> void:
	if state != current_state:
		return
		
	var new_state : State = states.get(new_state_name.to_lower())
	if !new_state or new_state == current_state:
		return
		
	if current_state:
		current_state.exit(new_state)
	
	new_state.enter()
	current_state = new_state
