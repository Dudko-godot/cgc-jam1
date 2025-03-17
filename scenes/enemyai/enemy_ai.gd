extends Node

@export var character: CharacterBody2D
@export var target_nodes: Array[NodePath] = []
@export_range(0, 100) var chase_player_chance: int = 30  # Шанс погнаться за игроком в процентах

var resolved_targets: Array[Node2D] = []
var navigation_component: Node2D
var current_patrol_point = null
var is_waiting_for_action = false
var rng = RandomNumberGenerator.new()

func _ready():
	rng.randomize()
	
	# Находим компонент навигации
	navigation_component = character.get_node("NavigationComponent")
	if not navigation_component:
		push_error("NavigationComponent не найден!")
		return

	# Преобразуем NodePath в реальные узлы
	for path in target_nodes:
		var node = get_node(path)
		if node:
			resolved_targets.append(node)
	
	# Проверяем наличие целей
	if resolved_targets.is_empty():
		push_error("Цели не заданы!")
		return

	# Подключаем сигнал о достижении цели
	navigation_component.connect("navigation_finished", Callable(self, "_on_navigation_finished"))

	# Устанавливаем первую цель
	_proceed_to_next_target()

func _switch_target(new_target: Node2D) -> void:
	if current_patrol_point and current_patrol_point.has_signal("action_finished"):
		# Отключаем предыдущий сигнал, если он был
		if current_patrol_point.is_connected("action_finished", Callable(self, "_on_action_finished")):
			current_patrol_point.disconnect("action_finished", Callable(self, "_on_action_finished"))
	
	current_patrol_point = new_target
	navigation_component.set_target(new_target)
	print("Переключение на новую цель: ", new_target.name)

func _on_navigation_finished() -> void:
	print("Достигнута цель: ", current_patrol_point.name)
	if is_waiting_for_action:
		print("Пропуск: ожидание действия")
		return
		
	if current_patrol_point.has_method("trigger_action"):
		print("Запуск действия для точки: ", current_patrol_point.name)
		is_waiting_for_action = true
		if not current_patrol_point.is_connected("action_finished", Callable(self, "_on_action_finished")):
			current_patrol_point.connect("action_finished", Callable(self, "_on_action_finished"))
		current_patrol_point.trigger_action(character)
	else:
		print("Точка не имеет действий, выбираем следующую")
		_proceed_to_next_target()

func _on_action_finished() -> void:
	print("Действие завершено для точки: ", current_patrol_point.name)
	is_waiting_for_action = false
	_proceed_to_next_target()

func _proceed_to_next_target() -> void:
	var new_target: Node2D
	var roll = rng.randi_range(1, 100)
	print("Бросок кости: ", roll, " (нужно <= ", chase_player_chance, ")")
	
	# Бросаем кость для определения следующей цели
	if roll <= chase_player_chance:
		# Преследуем игрока (первый элемент в массиве)
		new_target = resolved_targets[0]
		print("Выбрана цель: игрок (roll <= chance)")
	else:
		# Случайная точка патрулирования (кроме игрока)
		if resolved_targets.size() > 1:
			var patrol_points = resolved_targets.slice(1)  # Все точки кроме игрока
			var random_index = rng.randi() % patrol_points.size()
			new_target = patrol_points[random_index]
			print("Выбрана случайная точка патрулирования [", random_index, "]: ", new_target.name)
		else:
			# Если точек патрулирования нет, идём к игроку
			new_target = resolved_targets[0]
			print("Нет точек патрулирования, идём к игроку")
	
	if new_target == current_patrol_point:
		print("Выбрана та же цель, пробуем еще раз")
		_proceed_to_next_target()
		return
		
	_switch_target(new_target) 
