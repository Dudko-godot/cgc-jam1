extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	var _chosen_index : int = randi() % get_child_count()
	
	for _index in range(get_child_count() - 1, -1, -1):
		if _index == _chosen_index : continue
		get_child(_index).queue_free()
