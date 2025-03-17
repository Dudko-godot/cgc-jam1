class_name PhaseComponent extends Resource

var visuals : CharacterVisuals
var tracker : PhaseTracker

@export var is_directional : bool = false

signal value_changed


func attach_visuals(visuals_ : CharacterVisuals) -> void:
	visuals = visuals_
	if not is_directional : return
	visuals.direction_changed.connect(_on_direction_changed, CONNECT_DEFERRED)
	_on_direction_changed.call_deferred(visuals.direction)


func attach_tracker(tracker_ : PhaseTracker) -> void:
	tracker = tracker_
	tracker.phase_changed.connect(_on_phase_changed)
	_on_phase_changed.call_deferred(tracker.phase)


func _on_direction_changed(direction_ : CharacterVisuals.DIRECTION) -> void:
	calculate_direction(tracker.phase, direction_)
	

func _on_phase_changed(phase_ : float) -> void:
	if is_directional:
		calculate_direction(phase_, visuals.direction)
	else:
		calculate(phase_)


func calculate(phase_ : float) -> Variant:
	return 0


func calculate_direction(phase_ : float, direction_ : CharacterVisuals.DIRECTION) -> Variant:
	match direction_:
		CharacterVisuals.DIRECTION.UP:
			return _calculate_up(phase_)
		CharacterVisuals.DIRECTION.DOWN:
			return _calculate_down(phase_)
		CharacterVisuals.DIRECTION.LEFT:
			return _calculate_left(phase_)
		CharacterVisuals.DIRECTION.RIGHT:
			return _calculate_right(phase_)
	return 0


func _calculate_up(phase_ : float) -> Variant:
	return 0
	
	
func _calculate_down(phase_ : float) -> Variant:
	return 0
	
	
func _calculate_left(phase_ : float) -> Variant:
	return 0
	
	
func _calculate_right(phase_ : float) -> Variant:
	return 0
