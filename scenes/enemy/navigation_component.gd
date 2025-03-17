extends Node2D

signal navigation_finished

@export var speed: float = 300.0
@onready var navigation_agent: NavigationAgent2D = $NavigationAgent2D

var target_node: Node2D = null

func set_target(new_target: Node2D) -> void:
	target_node = new_target

func _physics_process(_delta: float) -> void:
	if not target_node or not is_instance_valid(target_node):
		return

	var parent = get_parent()
	if not parent is CharacterBody2D:
		return
		
	# Берём глобальную позицию цели
	var target_position = target_node.global_position
	# Указываем её агенту как цель
	navigation_agent.target_position = target_position

	var current_agent_position = global_position
	var next_path_position = navigation_agent.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * speed

	if navigation_agent.is_navigation_finished():
		navigation_finished.emit()
		return

	if navigation_agent.avoidance_enabled:
		navigation_agent.set_velocity(new_velocity)
	else:
		_on_navigation_agent_velocity_computed(new_velocity)

func _on_navigation_agent_velocity_computed(safe_velocity: Vector2) -> void:
	if get_parent() is CharacterBody2D:
		var parent = get_parent() as CharacterBody2D
		parent.velocity = safe_velocity
		parent.move_and_slide() 
