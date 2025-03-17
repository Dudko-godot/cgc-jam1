class_name DirectionComponentVisibility extends DirectionComponent

## Определяет видимость объекта в зависимости от направления движения NPC

@export_group('Settings')
@export_flags('UP:1','DOWN:2', 'LEFT:4', 'RIGHT:8') var visibility_flags := 0

signal hide
signal show

var is_visible : bool : set = _set_is_visible

func _set_is_visible(is_visible_ : bool) -> void:
	if is_visible == is_visible_ : return
	
	is_visible = is_visible_
	
	if is_visible:
		show.emit()
	else:
		hide.emit()


func _on_direction_changed(direction_ : CharacterVisuals.DIRECTION) -> void:
	if visibility_flags & direction_:
		is_visible = true
	else:
		is_visible = false

func _attach_actor_signals(actor_ : Node2D = actor) -> void:
	hide.connect(actor_.hide)
	show.connect(actor_.show)
	super(actor_)


func _force_emit() -> void:
	_on_direction_changed.call_deferred(visuals.direction)
		
	if is_visible:
		show.emit()
	else:
		hide.emit()


	
#func attach_visuals(visuals_ : CharacterVisuals) -> void:
	#super(visuals_)
	#visuals.direction_changed.connect(_on_direction_changed, CONNECT_DEFERRED)
	#_on_direction_changed.call_deferred(visuals.direction)
