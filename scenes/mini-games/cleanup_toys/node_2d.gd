extends Node2D


func _ready() -> void:
	randomize()
	get_children()[randi() % get_child_count()].show()
