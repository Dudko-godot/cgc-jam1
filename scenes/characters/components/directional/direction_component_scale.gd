class_name DirectionComponentScale extends DirectionComponent

@export var up : Vector2 = Vector2.ONE
@export var down : Vector2 = Vector2.ONE
@export var left : Vector2 = Vector2.ONE
@export var right : Vector2 = Vector2.ONE


var scale : Vector2 = Vector2.ZERO : set = _set_scale

signal scale_changed(scale_ : Vector2)


func _set_scale(scale_ : Vector2) -> void:
	if scale == scale_ : return
	scale = scale_
	
	scale_changed.emit()


func _on_direction_changed(direction_ : CharacterVisuals.DIRECTION) -> void:
	match direction_ :
		CharacterVisuals.DIRECTION.UP:
			scale = up
		CharacterVisuals.DIRECTION.DOWN:
			scale = down
		CharacterVisuals.DIRECTION.LEFT:
			scale = left
		CharacterVisuals.DIRECTION.RIGHT:
			scale = right



func attach_actor_signals(actor_ : Node2D = actor) -> void:
	scale_changed.connect(actor_.set_scale)
