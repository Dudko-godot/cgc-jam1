extends Node2D

@onready var player = $Player

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
		game_tasks.generate_random_tasks(2)  # Активируем 3 случайные задачи

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

func _on_minigame_cancelled(_minigame_name):
	# Включаем управление игроком после мини-игры
	if player:
		player.set_process_input(true)
		player.set_physics_process(true) 
