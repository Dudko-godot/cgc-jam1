class_name PhaseTracker extends Node

@export_group('External References')
@export var visuals : CharacterVisuals

@export_group('Settings')
@export_range(0.0, 3.0) var reset_ratio : float = 0.5
@export_range(0.0, 100.0) var raw_speed_reset_margin : float = 15.0
@export_range(0.01, 10.0, 0.01) var speed_multiplier : float = 12.0

@export var is_inverted : bool = false
@export var offset : float = 0.0

const RAW_CLAMP : float = 2.0#2 * PI
const PHASE_FRACTION : int = 10000
const BUFFER_SIZE_SECONDS : int = 3

var buffer_length_frames : int = 120

var raw_speed : float = 0.0 : set = _set_raw_speed
var raw : float = 0.0 : set = _set_raw

var phase : float = 0.0 : set = _set_phase

signal phase_changed(phase_ : float)

var buffer : PackedFloat32Array = []



func _set_phase(value_ : float) -> void:
	if phase == value_ : return
	phase = value_
	
	phase_changed.emit(phase)


func _set_raw(value_ : float) -> void:
	var current_offset : float = offset * visuals.relative_speed
	
	raw = value_
	
	#phase = -1.0 + triangle_wave(raw / PHASE_FRACTION, 8.0, 2.0)
	phase = sin(raw / PHASE_FRACTION - current_offset)
	if is_inverted:
		phase =- phase
	
	
#	raw = wrap(value_, 0, RAW_CLAMP)
	#phase = -1.0 + wrap(raw , 0.0, 2.0)
	#phase = 
	#phase = sin(raw / PHASE_FRACTION)


func _set_raw_speed(value_ : float) -> void:
	raw_speed = value_
	if raw_speed < raw_speed_reset_margin:
		raw_speed = 0.0


func _ready() -> void:
	_prepare_buffer()
	

func _physics_process(delta_ : float) -> void:
	var _body_velocity : float = 0.0
	if visuals and visuals.body : _body_velocity = visuals.body.velocity.length()
	
	raw_speed = _body_velocity * speed_multiplier
	
	if raw_speed < raw_speed_reset_margin:
		_interpolate_phase_reset(delta_)
	else:
		raw += raw_speed + delta_
	
	buffer.append(phase)
	buffer.remove_at(0)
	
	#print('raw_speed : {raw_speed}\nphase : {phase}'.format(
			#{
				#'raw_speed' :  raw_speed,
				#'phase' : phase
			#}
		#)
	#)
	
	
func _interpolate_phase_reset(delta_ : float) -> void:
	const MIN_INTERPOLATE_SPEED : float = 0.1
	const MAX_INTERPOLATE_SPEED : float = 0.5
	phase = lerp(phase, 0.0, clamp(delta_ * 0.5, MIN_INTERPOLATE_SPEED, MAX_INTERPOLATE_SPEED))


func _prepare_buffer() -> void:
	buffer_length_frames = BUFFER_SIZE_SECONDS * Engine.max_fps
	buffer.resize(buffer_length_frames)
	
	
	
func triangle_wave(t : float, p : float, amplitude : float) -> float:
	# Normalize time t to the range of [0, 1] based on the period
	var normalized_time = fmod(t, p) / p
		# Map the normalized time to a triangle wave
	if normalized_time < 0.5:
		return normalized_time * 2 * amplitude  # Rising part
	else:
		return (1.0 - normalized_time) * 2 * amplitude  # Falling part
