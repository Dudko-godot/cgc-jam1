class_name DirectionComponentPosition extends DirectionComponent

@export var up : Vector2 = Vector2.ZERO
@export var down : Vector2 = Vector2.ZERO
@export var left : Vector2 = Vector2.ZERO
@export var right : Vector2 = Vector2.ZERO

var position : Vector2 = Vector2.ZERO : set = _set_position

signal position_changed(position_ : Vector2)


func _set_position(position_ : Vector2) -> void:
	if position == position_ : return
	position = position_
	
	position_changed.emit(position)


func _on_direction_changed(direction_ : CharacterVisuals.DIRECTION) -> void:
	match direction_ :
		CharacterVisuals.DIRECTION.UP:
			position = up
		CharacterVisuals.DIRECTION.DOWN:
			position = down
		CharacterVisuals.DIRECTION.LEFT:
			position = left
		CharacterVisuals.DIRECTION.RIGHT:
			position = right


func _attach_actor_signals(actor_ : Node2D = actor) -> void:
	position_changed.connect(actor_.set_position)
