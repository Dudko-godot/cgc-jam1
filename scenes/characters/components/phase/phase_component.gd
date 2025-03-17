class_name PhaseComponent extends Resource

var visuals : CharacterVisuals
var tracker : PhaseTracker
var actor : Node2D
var default : Variant

enum PROPERTY {
	POSITION,
	ROTATION,
	SCALE,
	NONE
}

## How much in secodnd does this animation lag behind
## Pay attention to PhaseTracker.buffer_length_frames
@export_range(0.0, 2.0, 0.01) var delay : float = 0.0
@export var is_directional : bool = false
@export var default_property : PROPERTY

@warning_ignore('unused_signal')
signal value_changed

var delay_frames : int = 0 


func attach_visuals(visuals_ : CharacterVisuals) -> void:
	visuals = visuals_
	if not is_directional : return
	visuals.direction_changed.connect(_on_direction_changed, CONNECT_DEFERRED)
	_on_direction_changed.call_deferred(visuals.direction)

## Delay also gets determined here
func attach_tracker(tracker_ : PhaseTracker) -> void:
	tracker = tracker_
	tracker.phase_changed.connect(_on_phase_changed.unbind(1))
	_on_phase_changed.call_deferred(tracker.phase)
	_determine_delay()


func attach_actor(actor_ : Node2D, attach_signals : bool = true) -> void:
	actor = actor_
	_save_default()
	if not attach_signals : return
	_attach_actor_signals(actor)


func _determine_delay() -> void:
	delay_frames = floor(delay * Engine.max_fps)
	print('Delay in frames is ' + str(delay_frames))


func _fetch_phase() -> float:
	if not tracker : return 0.0
	
	if delay_frames == 0 : return tracker.phase
	
	if delay_frames < tracker.buffer_length_frames: return tracker.buffer[-delay_frames]
	
	return 0.0

func _attach_actor_signals(_actor : Node2D) -> void:
	pass
	#_force_emit()

func _on_direction_changed(direction_ : CharacterVisuals.DIRECTION) -> void:
	calculate_direction(_fetch_phase(), direction_)
	

func _on_phase_changed(phase_ : float = _fetch_phase()) -> void:
	if is_directional:
		calculate_direction(phase_, visuals.direction)
	else:
		calculate(phase_)



func calculate_direction(phase_ : float, direction_ : CharacterVisuals.DIRECTION) -> Variant:
	#print('Phase is ' + str(phase_) + ' dir is ' + str(direction_))
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


func _save_default() -> void:
	match default_property:
		PROPERTY.NONE:
			return
		PROPERTY.POSITION:
			default = actor.position
		PROPERTY.SCALE:
			default = actor.scale
		PROPERTY.ROTATION:
			default = actor.rotation
	

func calculate(_phase : float) -> Variant:
	return 0


func _calculate_up(_phase : float) -> Variant:
	return 0
	
	
func _calculate_down(_phase : float) -> Variant:
	return 0
	
	
func _calculate_left(_phase : float) -> Variant:
	return 0
	
	
func _calculate_right(_phase : float) -> Variant:
	return 0

## As in call the function below
func _invoke_callable_soften(value_ : Variant, callable_ : Callable) -> void:
	callable_.call(interpolated_for_relative_speed(value_))

func interpolated_for_relative_speed(value_ : Variant) -> Variant:
	return lerp(default, value_, visuals.relative_speed)
