class_name CharacterVisuals extends Node2D


@export_group('External References')
@export var body : CharacterBody2D
@export_group('Settings')
#@export_range(0.0, 20.0, 0.1) var phase_multiplier = 2.0
@export var maximum_velocity : float = 50.0
@export var determine_direction_from_velocity : bool = false
@export_group('Debug Utils')
@export var print_relative_speed : bool = false
@export var print_absolute_speed : bool = false

const MINIMUM_VELOCITY : float = 0.01

var relative_speed : float = 0.0

var direction : DIRECTION = DIRECTION.DOWN : set = _set_direction

enum STATE {
	DEFAULT, # Standing or walking
	CUSTOM
}

enum DIRECTION {
	UP = 1,
	DOWN = 2,
	LEFT = 4,
	RIGHT = 8
}

signal direction_changed(new_direction : DIRECTION)


func _set_direction(direction_ : DIRECTION) -> void:
	if direction == direction_ : return
	direction = direction_
	
	direction_changed.emit(direction_)


func _physics_process(_delta : float) -> void:
	if not body : return
	
	_determine_speed()
	_determine_direction()
	
	#
#func _determine_acceleration() -> void:
	#body.velocity

func _determine_speed() -> void:
	if body.velocity.length() < MINIMUM_VELOCITY:
		relative_speed = 0.0
	else:
		relative_speed = clampf(body.velocity.length() / maximum_velocity, 0.0, 1.0)

	if print_relative_speed : print('relative_speed : ' + str(relative_speed))
	if print_absolute_speed: print('absolute_speed : ' + str(body.velocity.length() ) )


func _determine_direction() -> void:
	if body.velocity.length() < MINIMUM_VELOCITY : return
	
	var _angle : float = rad_to_deg(body.velocity.angle_to(Vector2(1, -0.5))) #rad_to_deg(body.velocity.angle())
	
	if not determine_direction_from_velocity : return
	
	if _angle > 0.0:
		if _angle < 120.0:
			direction = DIRECTION.UP
		else:
			direction = DIRECTION.LEFT
	else:
		if abs(_angle) < 60.0:
			direction = DIRECTION.RIGHT
		else:
			direction = DIRECTION.DOWN
