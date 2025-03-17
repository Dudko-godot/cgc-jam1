extends CharacterBody2D

@export var speed: float = 300.0
@export var target_node: Node2D

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var label: Label = $Node2D/Label

# Сигнал для изменения целевого узла
signal target_changed(new_target: Node2D)

func _ready():
	# Подключаем обработчик сигнала
	connect("target_changed", Callable(self, "_on_target_changed"))

func _physics_process(delta: float) -> void:
	# Если цель не установлена или недействительна, ничего не делаем
	if not target_node or not is_instance_valid(target_node):
		return

	# Берём глобальную позицию цели
	var target_position = target_node.global_position
	# Указываем её агенту как цель
	navigation_agent_2d.target_position = target_position

	var current_agent_position = global_position
	var next_path_position = navigation_agent_2d.get_next_path_position()
	var new_velocity = current_agent_position.direction_to(next_path_position) * speed

	if navigation_agent_2d.is_navigation_finished():
		return

	if navigation_agent_2d.avoidance_enabled:
		navigation_agent_2d.set_velocity(new_velocity)
	else:
		_on_navigation_agent_2d_velocity_computed(new_velocity)

func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

# Обработчик сигнала изменения цели
func _on_target_changed(new_target: Node2D):
	target_node = new_target
	print("Цель изменена на: ", new_target.name)
