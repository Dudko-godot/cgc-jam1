extends Control

# Ссылки на ноды
@onready var task_container = %TaskContainer
@onready var task_item_template = %TaskItemTemplate

func _ready():
	# Скрываем шаблон
	task_item_template.visible = false
	
	# Подключаемся к сигналам GameTasks
	var game_tasks = get_node("/root/GameTasks")
	game_tasks.task_state_changed.connect(_on_task_state_changed)
	game_tasks.task_list_updated.connect(_update_task_list)
	
	# Обновляем список задач
	_update_task_list()

# Обновление списка задач
func _update_task_list():
	# Очищаем контейнер
	for child in task_container.get_children():
		if child != task_item_template:
			child.queue_free()
	
	# Получаем списки задач
	var game_tasks = get_node("/root/GameTasks")
	var active_tasks = game_tasks.get_active_tasks()
	var completed_tasks = game_tasks.get_completed_tasks()
	
	# Добавляем активные задачи
	for task in active_tasks:
		_add_task_item(task, false)
	
	# Добавляем выполненные задачи
	for task in completed_tasks:
		_add_task_item(task, true)

# Добавление элемента задачи в список
func _add_task_item(task, is_completed):
	# Создаем копию шаблона
	var task_item = task_item_template.duplicate()
	task_item.visible = true
	
	# Настраиваем элемент
	task_item.get_node("CheckBox").text = task["title"]
	task_item.get_node("Description").text = task["description"]
	
	# Отмечаем выполненные задачи
	if is_completed:
		task_item.get_node("CheckBox").button_pressed = true
		task_item.modulate = Color(0.7, 0.7, 0.7)
	
	# Добавляем в контейнер
	task_container.add_child(task_item)

# Обработчик изменения состояния задачи
func _on_task_state_changed(_task_id, _new_state):
	_update_task_list() 
