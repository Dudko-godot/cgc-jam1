class_name PhaseTracker extends Node

@export_group('External References')
@export var visuals : CharacterVisuals

@export_group('Settings')
@export_range(0.0, 3.0) var reset_ratio : float = 0.5
@export_range(0.0, 100.0) var raw_speed_reset_margin : float = 15.0

const RAW_CLAMP : float = 2 * PI

var raw_speed : float = 0.0 : set = _set_raw_speed
var raw : float = 0.0 : set = _set_raw

var phase : float = 0.0 : set = _set_phase

signal phase_changed(phase_ : float)

func _set_phase(value_ : float) -> void:
	if phase == value_ : return
	phase = value_
	
	phase_changed.emit(phase)


func _set_raw(value_ : float) -> void:
	raw = wrap(value_, 0, RAW_CLAMP)
	phase = sin(raw)


func _set_raw_speed(value_ : float) -> void:
	raw_speed = value_
	if raw_speed < raw_speed_reset_margin:
		raw_speed = 0.0


func _physics_process(delta_ : float) -> void:
	if raw_speed < raw_speed_reset_margin:
		_interpolate_phase_reset(delta_)
	else:
		raw += raw_speed + delta_
	
func _interpolate_phase_reset(delta_ : float) -> void:
	phase = lerp(phase, 0.0, delta_)
