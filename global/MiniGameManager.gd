extends Node

# Сигналы для коммуникации с другими объектами
# Используем сигналы с префиксом, чтобы избежать предупреждений
signal minigame_started_signal(minigame_name)
signal minigame_completed_signal(minigame_name)
signal minigame_cancelled_signal(minigame_name)

# Переменные для отслеживания текущей мини-игры
var current_minigame = null
var current_minigame_name = ""
var minigame_canvas_layer = null
var minigame_active = false  # Флаг активности мини-игры

# Словарь с путями к сценам мини-игр
var minigames = {
	"test_game": "res://scenes/mini-games/test_game/test-game.tscn",
	"sink": "res://scenes/mini-games/washing_dishes/sink.tscn",
	"homework": "res://scenes/mini-games/homework/homework.tscn"
}

# Запуск мини-игры по имени
func start_minigame(minigame_name: String):
	# Проверяем, не активна ли уже мини-игра
	if minigame_active:
		return false
	
	if minigame_name in minigames:
		var file_path = minigames[minigame_name]
		
		# Проверяем существование файла
		if not ResourceLoader.exists(file_path):
			return false
		
		# Создаём слой для отображения мини-игры поверх основной игры
		minigame_canvas_layer = CanvasLayer.new()
		minigame_canvas_layer.layer = 10
		get_tree().root.add_child(minigame_canvas_layer)
		
		# Загружаем и создаём экземпляр мини-игры
		var minigame_scene = load(file_path)
		
		if minigame_scene == null:
			minigame_canvas_layer.queue_free()
			minigame_canvas_layer = null
			return false
		
		current_minigame = minigame_scene.instantiate()
		minigame_canvas_layer.add_child(current_minigame)
		
		# Подключаем сигналы
		if current_minigame.has_signal("game_completed"):
			current_minigame.connect("game_completed", _on_minigame_completed)
		
		if current_minigame.has_signal("game_cancelled"):
			current_minigame.connect("game_cancelled", _on_minigame_cancelled)
		
		# Запоминаем имя текущей мини-игры и устанавливаем флаг активности
		current_minigame_name = minigame_name
		minigame_active = true
		
		# Отправляем сигнал о запуске мини-игры
		minigame_started_signal.emit(minigame_name)
		
		return true
	else:
		return false

# Закрытие текущей мини-игры
func close_minigame():
	if current_minigame != null:
		current_minigame.queue_free()
		minigame_canvas_layer.queue_free()
		
		current_minigame = null
		minigame_canvas_layer = null
		current_minigame_name = ""
		minigame_active = false

# Обработчики сигналов от мини-игры
func _on_minigame_completed():
	minigame_completed_signal.emit(current_minigame_name)
	close_minigame()

func _on_minigame_cancelled():
	minigame_cancelled_signal.emit(current_minigame_name)
	close_minigame()

# Проверка, активна ли мини-игра
func is_minigame_active() -> bool:
	return minigame_active 
