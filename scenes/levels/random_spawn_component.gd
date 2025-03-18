class_name RandomSpawnComponent extends Node

@export var actor : Node2D
@export var locations : Array[Marker2D]
@export var onready : bool = false ## Fire off automatically when ready
@export var deferred : bool = false ## Applies the position at the end of a frame

func apply_random() -> void:
	seed(Engine.get_frames_drawn())
	if deferred:
		actor.set_position.call_deferred(locations.pick_random().position)
	else:
		actor.position = locations.pick_random().position


func _ready() -> void:
	if not onready : return
	apply_random()
