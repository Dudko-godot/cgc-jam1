class_name VectorPhaseComponent extends PhaseComponent

@export_group('Tuples')
## Use this one for components that do not care about directions
@export var up : VectorTuple
@export var down : VectorTuple
@export var left : VectorTuple
@export var right : VectorTuple

var value : Vector2 = Vector2.ZERO : set = _set_value


func _set_value(value_ : Vector2) -> void:
	if value == value_ : return
	value = value_
	
	value_changed.emit(value)

#func _init() -> void:
	#if up and (down or left or right):
		#is_directional = true
	#else:
		#false

func calculate(phase_ : float) -> Vector2:
	value = up.interpolate(default, phase_)
	return value


func _calculate_up(phase_ : float) -> Vector2:
	if not up : return default
	value = up.interpolate(default, phase_)
	return value
	
	
func _calculate_down(phase_ : float) -> Vector2:
	if not down : return default
	value = down.interpolate(default, phase_)
	return value
	
	
func _calculate_left(phase_ : float) -> Vector2:
	if not left : return default
	value = left.interpolate(default, phase_)
	return value
	
	
func _calculate_right(phase_ : float) -> Vector2:
	if not right : return default
	value = right.interpolate(default, phase_)
	return value


func _attach_actor_signals(_actor : Node2D) -> void:
	match default_property:
		PhaseComponent.PROPERTY.SCALE:
			value_changed.connect(_invoke_callable_soften.bind(actor.set_scale))
			#value_changed.connect(actor.set_scale)
		PhaseComponent.PROPERTY.POSITION:
			value_changed.connect(_invoke_callable_soften.bind(actor.set_position))
			#value_changed.connect(actor.set_position)
