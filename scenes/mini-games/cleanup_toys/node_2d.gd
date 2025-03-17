extends Node2D


func _ready() -> void:
	randomize()
	var _index : int = randi() % get_child_count()
	print(_index)
	get_children()[randi() % get_child_count()].show()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass