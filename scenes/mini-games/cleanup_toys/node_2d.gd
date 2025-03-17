extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	get_children()[randi() % get_child_count()].show() # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
