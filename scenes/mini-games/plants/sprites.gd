extends Node2D



func _ready() -> void:
	randomize()
	
	var _chosen_index : int = randi() % get_child_count()
	
	for _index : int in range(get_child_count() -1, -1, -1):
		if _index == _chosen_index:
			get_child(_index).show()
			continue
		get_child(_index).free()
