class_name DirectionComponent extends Resource

var visuals : CharacterVisuals
var actor : Node2D

## Определяет видимость объекта в зависимости от направления движения NPC

func _on_direction_changed(_direction : CharacterVisuals.DIRECTION) -> void:
	pass


func attach_visuals(visuals_ : CharacterVisuals) -> void:
	visuals = visuals_
	visuals.direction_changed.connect(_on_direction_changed, CONNECT_DEFERRED)
	_on_direction_changed.call_deferred(visuals.direction)


func attach_actor(actor_ : Node2D, attach_signals : bool = true) -> void:
	actor = actor_
	if not attach_signals : return
	attach_actor_signals(actor)

func attach_actor_signals(_actor : Node2D) -> void:
	pass
