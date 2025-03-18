extends Node2D

@export var loader : LoaderThreaded

const PATH : String = 'res://scenes/levels/game.tscn'


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loader.start_loading(PATH)
