extends Control

signal game_completed
signal game_cancelled

@onready var solved_problems = $Paper/MarginContainer/VBoxContainer/SolvedProblems
@onready var current_problem = $Paper/MarginContainer/VBoxContainer/CurrentProblem
@onready var answer_options = $AnswerOptions
@onready var homework_theme = preload("res://scenes/mini-games/homework/homework_theme.tres")

var homework_manager: Node
var problems_to_complete = 4
var buttons_disabled = false
var wrong_answer_timer: Timer

func _ready() -> void:
	homework_manager = Node.new()
	homework_manager.set_script(load("res://scenes/mini-games/homework/homework_manager.gd"))
	add_child(homework_manager)
	
	homework_manager.homework_completed.connect(_on_homework_completed)
	current_problem.theme = homework_theme
	
	# Создаем таймер для отключения кнопок
	wrong_answer_timer = Timer.new()
	wrong_answer_timer.one_shot = true
	wrong_answer_timer.wait_time = 3.0
	wrong_answer_timer.timeout.connect(_on_wrong_answer_timer_timeout)
	add_child(wrong_answer_timer)
	
	update_display()
	create_answer_buttons()

func update_display() -> void:
	current_problem.text = homework_manager.current_problem.text
	
	for child in solved_problems.get_children():
		child.queue_free()
	
	for problem in homework_manager.solved_problems:
		var label = Label.new()
		label.text = problem
		label.theme = homework_theme
		solved_problems.add_child(label)

func create_answer_buttons() -> void:
	for child in answer_options.get_children():
		child.queue_free()
	
	for answer in homework_manager.current_problem.options:
		var button = Button.new()
		button.text = str(answer)
		button.custom_minimum_size = Vector2(100, 60)
		button.theme = homework_theme
		button.pressed.connect(func(): on_answer_selected(answer))
		answer_options.add_child(button)

func on_answer_selected(answer: int) -> void:
	if buttons_disabled:
		return
		
	if homework_manager.check_answer(answer):
		update_display()
		create_answer_buttons()
	else:
		# Неправильный ответ - отключаем кнопки и показываем уведомление
		buttons_disabled = true
		set_buttons_disabled(true)
		show_wrong_answer_notification()
		wrong_answer_timer.start()

func set_buttons_disabled(disabled: bool) -> void:
	for button in answer_options.get_children():
		button.disabled = disabled

func show_wrong_answer_notification() -> void:
	var notification = Label.new()
	notification.text = "Неправильный ответ!"
	notification.theme = homework_theme
	notification.add_theme_color_override("font_color", Color(1, 0, 0))
	notification.add_theme_font_size_override("font_size", 24)
	notification.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	
	# Добавляем уведомление над кнопками
	var notification_container = Control.new()
	notification_container.name = "WrongAnswerNotification"
	notification_container.size_flags_horizontal = Control.SIZE_FILL
	notification_container.size_flags_vertical = Control.SIZE_FILL
	notification_container.add_child(notification)
	
	# Удаляем предыдущее уведомление, если оно есть
	var existing_notification = get_node_or_null("WrongAnswerNotification")
	if existing_notification:
		existing_notification.queue_free()
	
	add_child(notification_container)
	notification.position = Vector2(
		(size.x - notification.size.x) / 2,
		answer_options.position.y - 100
	)

func _on_wrong_answer_timer_timeout() -> void:
	buttons_disabled = false
	set_buttons_disabled(false)
	
	# Удаляем уведомление
	var notification = get_node_or_null("WrongAnswerNotification")
	if notification:
		notification.queue_free()

func _on_homework_completed() -> void:
	game_completed.emit() 
