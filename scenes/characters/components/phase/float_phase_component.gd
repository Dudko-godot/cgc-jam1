class_name FloatPhaseComponent extends PhaseComponent

@export_group('Tuples')
## Use this one for components that do not care about directions
@export var up : FloatTuple
@export var down : FloatTuple
@export var left : FloatTuple
@export var right : FloatTuple

var value : float = 0.0 : set = _set_value


func _set_value(value_ : float) -> void:
	if value == value_ : return
	value = value_
	
	value_changed.emit(value)

#func _init() -> void:
	#if up and (down or left or right):
		#is_directional = true
	#else:
		#false

func calculate(phase_ : float) -> float:
	value = up.interpolate(default, phase_)
	return value


func _calculate_up(phase_ : float) -> float:
	if not up : return default
	value = up.interpolate(default, phase_)
	return value
	
	
func _calculate_down(phase_ : float) -> float:
	if not down : return default
	value = down.interpolate(default, phase_)
	return value
	
	
func _calculate_left(phase_ : float) -> float:
	if not left : return default
	value = left.interpolate(default, phase_)
	return value
	
	
func _calculate_right(phase_ : float) -> float:
	if not right : return default
	value = right.interpolate(default, phase_)
	return value


func _attach_actor_signals(_actor : Node2D) -> void:
	match default_property:
		PhaseComponent.PROPERTY.ROTATION:
			value_changed.connect(_invoke_callable_soften.bind(actor.set_rotation))
			#value_changed.connect(actor.set_rotation)
	#value_changed.connect()
