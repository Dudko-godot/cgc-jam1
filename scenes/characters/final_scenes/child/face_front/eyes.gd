extends Node2D

const LOWEST_PERIOD : float = 1.0
const HIGHEST_PERIOD : float = 12.0

@export var face : Node2D

@export var eye_l : EyeChild
@export var eye_r : EyeChild

var is_waiting : bool = false


#func _process(delta: float) -> void:

func _ready() -> void:
	_blink_randomly()

func _blink_randomly(is_recursive : bool = true) -> void:
	randomize()
	
	is_waiting = true
	await get_tree().create_timer(
		LOWEST_PERIOD + randf() * (HIGHEST_PERIOD - LOWEST_PERIOD)
		).timeout
		
	is_waiting = false
	
	if face.visible :
		eye_l.blink()
		eye_r.blink()
	
	if is_recursive:
		_blink_randomly()
