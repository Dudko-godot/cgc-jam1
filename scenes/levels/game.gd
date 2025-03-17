extends Node2D

@onready var player = %Player

# Экран победы
const VICTORY_SCREEN = "res://scenes/victory_screen/victory_screen.tscn"

func _ready():
	# Подключаемся к сигналам MiniGameManager
	if has_node("/root/MiniGameManager"):
		var mini_game_manager = get_node("/root/MiniGameManager")
		mini_game_manager.minigame_started_signal.connect(_on_minigame_started)
		mini_game_manager.minigame_completed_signal.connect(_on_minigame_completed)
		mini_game_manager.minigame_cancelled_signal.connect(_on_minigame_cancelled)
	
	# Генерируем случайный набор задач
	if has_node("/root/GameTasks"):
		var game_tasks = get_node("/root/GameTasks")
		game_tasks.generate_random_tasks(1)  # Активируем случайные задачи

func _on_minigame_started(_minigame_name):
	# Отключаем управление игроком во время мини-игры
	if player:
		player.set_process_input(false)
		player.set_physics_process(false)

func _on_minigame_completed(_minigame_name):
	# Включаем управление игроком после мини-игры
	if player:
		player.set_process_input(true)
		player.set_physics_process(true)
	
	# Проверяем, все ли задачи выполнены
	check_victory_condition()

func _on_minigame_cancelled(_minigame_name):
	# Включаем управление игроком после мини-игры
	if player:
		player.set_process_input(true)
		player.set_physics_process(true) 

# Проверка условия победы - все ли задачи выполнены
func check_victory_condition():
	if has_node("/root/GameTasks"):
		var game_tasks = get_node("/root/GameTasks")
		var active_tasks = []
		var completed_tasks = []
		
		# Собираем информацию о задачах
		for task_id in game_tasks.tasks:
			var state = game_tasks.get_task_state(task_id)
			if state == game_tasks.TaskState.ACTIVE:
				active_tasks.append(task_id)
			elif state == game_tasks.TaskState.COMPLETED:
				completed_tasks.append(task_id)
		
		# Если нет активных задач и есть выполненные
		if active_tasks.size() == 0 and completed_tasks.size() > 0:
			print("Все задачи выполнены! Показываем экран победы.")
			# Загружаем сцену победы динамически
			var victory_scene = load(VICTORY_SCREEN)
			get_tree().change_scene_to_packed(victory_scene)
