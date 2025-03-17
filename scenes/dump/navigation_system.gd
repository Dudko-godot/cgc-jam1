# navigation_component.gd
extends Node
class_name NavigationSystem

# Сигналы
signal destination_reached

# Настройки
@export var agent_path: NodePath
@export var move_speed: float = 300.0

# Внутренние переменные
var agent: NavigationAgent2D
var parent: CharacterBody2D

func _ready():
	# Получаем ссылку на родительский узел
	parent = get_parent()
	# Получаем ссылку на NavigationAgent2D
	if agent_path:
		agent = get_node(agent_path)    
	# Проверяем, что нашли NavigationAgent2D
	if not agent:
		push_error("NavigationComponent: NavigationAgent2D не найден!")
		return
	# Подключаем сигналы NavigationAgent2D
	agent.velocity_computed.connect(_on_velocity_computed)
	agent.navigation_finished.connect(_on_navigation_finished)

func _physics_process(_delta):
	# Если путь не завершен, двигаемся по нему
	if agent and not agent.is_navigation_finished():
		_follow_path()

# Установить цель для навигации
func set_target(target_position: Vector2):
	if agent:
		agent.target_position = target_position

# Следовать по текущему пути
func _follow_path():
	# Получаем следующую точку пути
	var next_position = agent.get_next_path_position()
	
	# Вычисляем направление и скорость
	var direction = parent.global_position.direction_to(next_position)
	var new_velocity = direction * move_speed
	
	# Устанавливаем скорость через NavigationAgent2D
	if agent.avoidance_enabled:
		agent.set_velocity(new_velocity)
	else:
		parent.velocity = new_velocity
		parent.move_and_slide()

# Проверить, достигнута ли цель
func is_target_reached() -> bool:
	if agent:
		return agent.is_navigation_finished()
	return true

# Обработчик сигнала velocity_computed от NavigationAgent2D
func _on_velocity_computed(safe_velocity: Vector2):
	parent.velocity = safe_velocity
	parent.move_and_slide()

# Обработчик сигнала navigation_finished от NavigationAgent2D
func _on_navigation_finished():
	destination_reached.emit()
