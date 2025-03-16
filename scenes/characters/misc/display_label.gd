extends Label

@export var visuals : CharacterVisuals


func _ready() -> void:
	visuals.direction_changed.connect(_on_direction_changed)
	
	
func _on_direction_changed(direction_ : CharacterVisuals.DIRECTION) -> void:
	match direction_:
		CharacterVisuals.DIRECTION.UP:
			text = 'up'
		CharacterVisuals.DIRECTION.DOWN:
			text = 'down'
		CharacterVisuals.DIRECTION.LEFT:
			text = 'left'
		CharacterVisuals.DIRECTION.RIGHT:
			text = 'right'
