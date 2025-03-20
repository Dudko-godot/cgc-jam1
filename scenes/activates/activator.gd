extends Area2D

# Стилевая корректировка от Frexitsch
const INTERACTABLE_PROMPT_LABEL_SETTINGS = preload('res://visuals/label_settings/interactable_prompt_label_settings.tres')

# Экспортируемые переменные
@export var task_id: String = "test_game"
# Переменные состояния
var player_in_range = false
var label : Label = null
var task_data = {}

func _ready():
	# Добавляем в группу активаторов
	add_to_group("activators")
	
	# Создаем метку для подсказки
	label = Label.new()
	label.visible = false
	label.label_settings = INTERACTABLE_PROMPT_LABEL_SETTINGS.duplicate()
	add_child(label)
	
	# Подключаем сигналы
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Подключаемся к сигналам GameTasks
	var game_tasks = get_node("/root/GameTasks")
	game_tasks.task_state_changed.connect(_on_task_state_changed)
	
	# Загружаем данные задачи
	_load_task_data()

func _process(_delta):
	# Обновляем позицию метки
	if label and label.visible:
		label.position = Vector2(-label.size.x / 2, -50)

func _input(event):
	# Проверяем нажатие клавиши взаимодействия
	if player_in_range and is_task_active() and event.is_action_pressed("interact"):
		_start_minigame()

func _on_body_entered(body):
	if body is CharacterBody2D:
		player_in_range = true
		_update_label()

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		label.visible = false

# Загрузка данных задачи
func _load_task_data():
	var game_tasks = get_node("/root/GameTasks")
	task_data = game_tasks.get_task(task_id)
	_update_visual_state()

# Обработчик изменения состояния задачи
func _on_task_state_changed(changed_task_id, _new_state):
	if changed_task_id == task_id:
		_load_task_data()

# Проверка, активна ли задача
func is_task_active() -> bool:
	var game_tasks = get_node("/root/GameTasks")
	return game_tasks.get_task_state(task_id) == game_tasks.TaskState.ACTIVE

# Запуск мини-игры
func _start_minigame():
	# Пытаемся получить доступ к MiniGameManager
	var mini_game_manager = get_node_or_null("/root/MiniGameManager")
	
	if mini_game_manager == null:
		return
	
	# Проверяем, не активна ли уже мини-игра
	if mini_game_manager.is_minigame_active():
		return
	
	# Запускаем мини-игру
	mini_game_manager.start_minigame(task_id)

# Обновление визуального состояния
func _update_visual_state():
	var game_tasks = get_node("/root/GameTasks")
	var state = game_tasks.get_task_state(task_id)
	
	# Визуальное отображение состояния
	match state:
		game_tasks.TaskState.ACTIVE:
			label.label_settings.font_color = Color(1, 1, 1, 1)
			#modulate = Color(1, 1, 1, 1)
		game_tasks.TaskState.COMPLETED:
			label.label_settings.font_color = Color(0.5, 1, 0.5, 0.7)
			#modulate = Color(0.5, 1, 0.5, 0.7)
		game_tasks.TaskState.FAILED:
			label.label_settings.font_color = Color(1, 0.5, 0.5, 0.7)
			#modulate = Color(1, 0.5, 0.5, 0.7)
		_:  # INACTIVE
			label.label_settings.font_color = '#b3c6e3' #Color(0.302, 0.169, 0.267)#Color(0.345, 0.616, 0.678)
			#modulate = Color(0.345, 0.616, 0.678) #Color(0.29, 0.337, 0.525) #'4a5686' #Color.LIGHT_BLUE #Color(0.5, 0.5, 0.5, 0.5)
			#label.label_settings.outline_size = 16
			#label.label_settings.outline_color = '#16263d'
			
			
	_update_label()

# Обновление текста подсказки
func _update_label():
	if not label or not player_in_range or task_data.is_empty():
		return
	
	label.visible = true
	
	var game_tasks = get_node("/root/GameTasks")
	var state = game_tasks.get_task_state(task_id)
	
	match state:
		game_tasks.TaskState.ACTIVE:
			label.text = '{interactable_propmt} {specific_prompt}'.format(
				{
					'interactable_propmt' : tr('INTERACTABLE_PROMPT'),
					'specific_prompt' : tr(task_data.get("prompt_text", "INTERACTABLE_INSTRUCTION_DEFAULT"))
				}
			)
		game_tasks.TaskState.COMPLETED:
			label.text = "TASK_COMPLETE"
		game_tasks.TaskState.FAILED:
			label.text = "TASK_FAILED"
		_:  # INACTIVE
			label.text = task_data.get("disabled_text", "UNAVALIABLE") 
