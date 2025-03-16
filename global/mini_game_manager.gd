extends Node

# Сигналы для коммуникации с другими объектами
# Используем сигналы с префиксом, чтобы избежать предупреждений
signal minigame_started_signal(task_id)
signal minigame_completed_signal(task_id)
signal minigame_cancelled_signal(task_id)

# Переменные для отслеживания текущей мини-игры
var current_minigame = null
var current_task_id = ""
var minigame_canvas_layer = null
var minigame_active = false  # Флаг активности мини-игры

# Запуск мини-игры по ID задачи
func start_minigame(task_id: String):
	# Проверяем, не активна ли уже мини-игра
	if minigame_active:
		return false
	
	# Получаем путь к сцене из GameTasks
	var game_tasks = get_node("/root/GameTasks")
	var scene_path = game_tasks.get_scene_path(task_id)
	
	if scene_path.is_empty():
		return false
	
	# Проверяем существование файла
	if not ResourceLoader.exists(scene_path):
		return false
	
	# Создаём слой для отображения мини-игры поверх основной игры
	minigame_canvas_layer = CanvasLayer.new()
	minigame_canvas_layer.layer = 10
	get_tree().root.add_child(minigame_canvas_layer)
	
	# Загружаем и создаём экземпляр мини-игры
	var minigame_scene = load(scene_path)
	
	if minigame_scene == null:
		minigame_canvas_layer.queue_free()
		minigame_canvas_layer = null
		return false
	
	current_minigame = minigame_scene.instantiate()
	minigame_canvas_layer.add_child(current_minigame)
	
	# Подключаем сигналы
	if current_minigame.has_signal("game_completed"):
		current_minigame.game_completed.connect(_on_minigame_completed)
	
	if current_minigame.has_signal("game_cancelled"):
		current_minigame.game_cancelled.connect(_on_minigame_cancelled)
	
	# Запоминаем ID текущей задачи и устанавливаем флаг активности
	current_task_id = task_id
	minigame_active = true
	
	# Отправляем сигнал о запуске мини-игры
	minigame_started_signal.emit(task_id)
	
	return true

# Закрытие текущей мини-игры
func close_minigame():
	if current_minigame != null:
		current_minigame.queue_free()
		minigame_canvas_layer.queue_free()
		
		current_minigame = null
		minigame_canvas_layer = null
		current_task_id = ""
		minigame_active = false

# Обработчики сигналов от мини-игры
func _on_minigame_completed():
	minigame_completed_signal.emit(current_task_id)
	close_minigame()

func _on_minigame_cancelled():
	minigame_cancelled_signal.emit(current_task_id)
	close_minigame()

# Проверка, активна ли мини-игра
func is_minigame_active() -> bool:
	return minigame_active 
