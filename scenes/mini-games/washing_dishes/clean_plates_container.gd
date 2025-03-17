extends VBoxContainer

const ANGLE_AMP : int = 16

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#randomize()
	seed(Engine.get_frames_drawn())
	rotation = deg_to_rad(-0.5 * ANGLE_AMP + randf() * ANGLE_AMP)
	print(rotation)
