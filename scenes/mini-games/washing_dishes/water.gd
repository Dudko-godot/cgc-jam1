extends TextureRect

const SPEED : float = 0.1

func _process(delta_ : float) -> void:
	rotation += delta_ * SPEED
