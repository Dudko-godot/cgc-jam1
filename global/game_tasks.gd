extends Node

# Сигналы
signal task_state_changed(task_id, new_state)
signal task_list_updated()

# Состояния задач
enum TaskState {
	INACTIVE,   # Задача неактивна
	ACTIVE,     # Задача активна и доступна
	COMPLETED,  # Задача выполнена
	FAILED      # Задача провалена
}

# Структура задачи:
# {
#   "id": String,                 # Уникальный идентификатор задачи
#   "title": String,              # Название задачи
#   "description": String,        # Описание задачи
#   "scene_path": String,         # Путь к сцене мини-игры
#   "state": TaskState,           # Текущее состояние задачи
#   "prompt_text": String,        # Текст подсказки при взаимодействии
#   "disabled_text": String       # Текст при неактивной задаче
# }

# Список всех задач
var tasks = {
	"wash_dishes": {
		"id": "wash_dishes",
		"title": "TASK_NAME_DISHES",
		"description": "TASK_DESC_DISHES",
		"scene_path": "res://scenes/mini-games/washing_dishes/sink.tscn",
		"state": TaskState.INACTIVE,
		"prompt_text": "TASK_PROMPT_DISHES",
		"disabled_text": "TASK_DISABLED_DISHES"
	},
	"do_homework": {
		"id": "do_homework",
		"title": "TASK_NAME_HOMEWORK",
		"description": "TASK_DESC_HOMEWORK",
		"scene_path": "res://scenes/mini-games/homework/homework.tscn",
		"state": TaskState.INACTIVE,
		"prompt_text": "TASK_PROMPT_HOMEWORK",
		"disabled_text": "TASK_DISABLED_HOMEWORK"
	},
	"test_game": {
		"id": "test_game",
		"title": "TASK_NAME_TEST",
		"description": "TASK_DESC_TEST",
		"scene_path": "res://scenes/mini-games/test_game/test_game.tscn",
		"state": TaskState.INACTIVE,
		"prompt_text": "TASK_PROMPT_TEST",
		"disabled_text": "TASK_DISABLED_TEST"
	},
	"hang_laundry": {
		"id": "hang_laundry",
		"title": "TASK_NAME_LAUNDRY",
		"description": "TASK_DESC_LAUNDRY",
		"scene_path": "res://scenes/mini-games/laundry/laundry.tscn",
		"state": TaskState.INACTIVE,
		"prompt_text": "TASK_PROMPT_LAUNDRY",
		"disabled_text": "TASK_DISABLED_LAUNDRY"
	},
	"cleanup_toys": {
		"id": "cleanup_toys",
		"title": "TASK_NAME_TOYS",
		"description": "TASK_DESC_TOYS",
		"scene_path": "res://scenes/mini-games/cleanup_toys/cleanup_toys.tscn",
		"state": TaskState.INACTIVE,
		"prompt_text": "TASK_PROMPT_TOYS",
		"disabled_text": "TASK_DISABLED_TOYS"
	},
	"cleanup_tv": {
		"id": "cleanup_tv",
		"title": "TASK_NAME_TV",
		"description": "TASK_DESC_TV",
		"scene_path": "res://scenes/mini-games/cleanup_tv/cleanup_tv.tscn",
		"state": TaskState.INACTIVE,
		"prompt_text": "TASK_PROMPT_TV",
		"disabled_text": "TASK_DISABLED_TV"
	},
	"water_plants": {
		"id": "water_plants",
		"title": "TASK_NAME_PLANTS",
		"description": "TASK_DESC_PLANTS",
		"scene_path": "res://scenes/mini-games/plants/plants.tscn",
		"state": TaskState.INACTIVE,
		"prompt_text": "TASK_PROMPT_PLANTS",
		"disabled_text": "TASK_DISABLED_PLANTS"
	}
	# Добавляйте новые задачи здесь
}

# Инициализация при запуске игры
func _ready():
	# Подключаемся к сигналам MiniGameManager
	var mini_game_manager = get_node("/root/MiniGameManager")
	mini_game_manager.minigame_completed_signal.connect(_on_minigame_completed)
	mini_game_manager.minigame_cancelled_signal.connect(_on_minigame_cancelled)

# Генерация случайного набора активных задач
func generate_random_tasks(count: int):
	# Сначала сбрасываем все задачи в неактивное состояние
	for task_id in tasks:
		set_task_state(task_id, TaskState.INACTIVE)
	
	# Получаем список всех задач и перемешиваем его
	var task_ids = tasks.keys()
	task_ids.shuffle()
	
	# Активируем нужное количество задач
	var tasks_to_activate = min(count, task_ids.size())
	for i in range(tasks_to_activate):
		set_task_state(task_ids[i], TaskState.ACTIVE)
	
	# Отправляем сигнал об обновлении списка задач
	task_list_updated.emit()

# Установка состояния задачи
func set_task_state(task_id: String, new_state: TaskState):
	if task_id in tasks:
		var old_state = tasks[task_id]["state"]
		if old_state != new_state:
			tasks[task_id]["state"] = new_state
			task_state_changed.emit(task_id, new_state)

# Получение состояния задачи
func get_task_state(task_id: String) -> int:
	if task_id in tasks:
		return tasks[task_id]["state"]
	return TaskState.INACTIVE

# Получение данных задачи
func get_task(task_id: String) -> Dictionary:
	if task_id in tasks:
		return tasks[task_id]
	return {}

# Получение пути к сцене мини-игры по ID задачи
func get_scene_path(task_id: String) -> String:
	if task_id in tasks:
		return tasks[task_id]["scene_path"]
	return ""

# Получение списка активных задач
func get_active_tasks() -> Array:
	var active = []
	for task_id in tasks:
		if tasks[task_id]["state"] == TaskState.ACTIVE:
			active.append(tasks[task_id])
	return active

# Получение списка выполненных задач
func get_completed_tasks() -> Array:
	var completed = []
	for task_id in tasks:
		if tasks[task_id]["state"] == TaskState.COMPLETED:
			completed.append(tasks[task_id])
	return completed

# Обработчик завершения мини-игры
func _on_minigame_completed(minigame_name: String):
	# Ищем задачу по имени мини-игры
	for task_id in tasks:
		if tasks[task_id]["id"] == minigame_name:
			set_task_state(task_id, TaskState.COMPLETED)
			break

# Обработчик отмены мини-игры
func _on_minigame_cancelled(_minigame_name: String):
	# При отмене состояние не меняется
	pass 

# Проверка, все ли активные задачи выполнены
# Frexitsch : на 19.03.25 эта функция нигде не используется
func are_all_tasks_completed() -> bool:
	var active_count = 0
	var completed_count = 0
	
	# Подсчитываем количество активных и выполненных задач
	for task_id in tasks:
		if tasks[task_id]["state"] == TaskState.ACTIVE:
			active_count += 1
		elif tasks[task_id]["state"] == TaskState.COMPLETED:
			completed_count += 1
	
	# Если нет активных задач и есть хотя бы одна выполненная
	return active_count == 0 and completed_count > 0
