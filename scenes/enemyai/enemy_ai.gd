class_name EnemyAIController extends Node

@export var character: CharacterBody2D
@export var target_nodes: Array[NodePath] = []
@export_range(0, 100) var chase_player_chance: int = 30  # Шанс погнаться за игроком в процентах
@export var detection_cooldown: float = 5.0  # Задержка перед повторным преследованием

var resolved_targets: Array[Node2D] = []
var navigation_component: Node2D
var current_patrol_point = null
var is_waiting_for_action = false
var allow_detection: bool = true  # Флаг разрешения преследования
var was_chasing_player: bool = false  # Флаг для отслеживания предыдущей цели
var rng = RandomNumberGenerator.new()
@onready var detection_timer: Timer = $Timer
@onready var player_point: Node2D = null  # Ссылка на точку следования за игроком
var navigation_ready: bool = false

var is_actively_chasing_player : bool = true : set = _set_is_actively_chasing_player

func _set_is_actively_chasing_player(value_ : bool) -> void:
	if is_actively_chasing_player == value_ : return
	is_actively_chasing_player = value_
	
	if is_actively_chasing_player:
		began_actively_chasing_player.emit()
	else:
		stopped_actively_chasing_player.emit()

signal began_actively_chasing_player
signal stopped_actively_chasing_player

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
	
	# Проверяем наличие целей и сохраняем ссылку на точку игрока
	if resolved_targets.is_empty():
		push_error("Цели не заданы!")
		return
	
	player_point = resolved_targets[0]  # Первый элемент - точка следования за игроком
	
	# Подключаем сигнал о достижении цели
	navigation_component.connect("navigation_finished", Callable(self, "_on_navigation_finished"))
	
	# Подключаем сигналы обнаружения игрока
	var detection_area = character.get_node("Area2D")
	if detection_area:
		detection_area.connect("body_entered", Callable(self, "_on_player_detected"))
	else:
		push_error("Area2D не найдена на персонаже!")
		return
		
	detection_timer.wait_time = detection_cooldown
	
	# Ждем один кадр, чтобы навигационная карта успела синхронизироваться
	await get_tree().process_frame
	navigation_ready = true

	# Устанавливаем первую цель
	# Станим батю ненадолго
	await get_tree().create_timer(1.2).timeout
	_proceed_to_next_target()

func _on_player_detected(body: Node2D) -> void:
	if not navigation_ready or not allow_detection:
		return
		
	# Проверяем, является ли тело игроком
	if body != player_point.get_parent():
		return
		
	# Прерываем текущее действие
	if current_patrol_point and is_waiting_for_action:
		is_waiting_for_action = false
		if current_patrol_point.has_signal("action_finished"):
			current_patrol_point.action_finished.emit()
	
	# Сбрасываем таймер
	detection_timer.stop()
	
	# Переключаемся на преследование игрока
	_switch_target(player_point)

func _switch_target(new_target: Node2D) -> void:
	if not navigation_ready:
		return
		
	if current_patrol_point and current_patrol_point.has_signal("action_finished"):
		# Отключаем предыдущий сигнал, если он был
		if current_patrol_point.is_connected("action_finished", Callable(self, "_on_action_finished")):
			current_patrol_point.disconnect("action_finished", Callable(self, "_on_action_finished"))
	
	was_chasing_player = (current_patrol_point == player_point)  # Запоминаем, преследовали ли игрока
	current_patrol_point = new_target
	navigation_component.set_target(new_target)
	
	# Обновляем состояние преследования согласно алгоритму
	if new_target == player_point:  # Если цель - точка игрока
		allow_detection = false  # Отключаем обнаружение
		is_actively_chasing_player = true
	else:  # Если другая точка патрулирования
		is_actively_chasing_player = false
		if was_chasing_player:  # Если до этого преследовали игрока
			allow_detection = false  # Временно запрещаем обнаружение
			detection_timer.start()  # Запускаем таймер перед следующим разрешением обнаружения
		else:
			allow_detection = true  # Разрешаем обнаружение

func _on_navigation_finished() -> void:
	if not navigation_ready:
		return
		
	if is_waiting_for_action:
		return
		
	if current_patrol_point.has_method("trigger_action"):
		is_waiting_for_action = true
		if not current_patrol_point.is_connected("action_finished", Callable(self, "_on_action_finished")):
			current_patrol_point.connect("action_finished", Callable(self, "_on_action_finished"))
		current_patrol_point.trigger_action(character)
	else:
		_proceed_to_next_target()

func _on_action_finished() -> void:
	is_waiting_for_action = false
	_proceed_to_next_target()

func _proceed_to_next_target() -> void:
	if not navigation_ready:
		return
		
	var new_target: Node2D
	var roll = rng.randi_range(1, 100)
	
	# Бросаем кость для определения следующей цели
	if roll <= chase_player_chance:
		# Преследуем игрока (первый элемент в массиве)
		new_target = player_point
	else:
		# Случайная точка патрулирования (кроме игрока)
		if resolved_targets.size() > 1:
			var patrol_points = resolved_targets.slice(1)  # Все точки кроме игрока
			var random_index = rng.randi() % patrol_points.size()
			new_target = patrol_points[random_index]
		else:
			# Если точек патрулирования нет, идём к игроку
			new_target = player_point
	
	if new_target == current_patrol_point:
		_proceed_to_next_target()
		return
		
	_switch_target(new_target) 

func _on_timer_timeout() -> void:
	allow_detection = true
	_proceed_to_next_target()
