extends Node
class_name State


@warning_ignore('unused_signal')
signal transitioned(source : State, new_state_name : String)


func enter() -> void:
	pass
	
	
func exit(_next_state : State) -> void:
	pass
	
	
func update(_delta : float) -> void:
	pass
	
	
func physics_update(_delta: float) -> void:
	pass
