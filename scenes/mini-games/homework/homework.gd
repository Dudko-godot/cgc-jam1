extends Control

signal game_completed
signal game_cancelled

@onready var solved_problems = %SolvedProblems
@onready var current_problem = %CurrentProblem
@onready var answer_options = %AnswerOptions
@onready var homework_theme = preload("res://scenes/mini-games/homework/homework_theme.tres")
const OPEN_THE_BOOK = preload("res://Audio/Sound/OpenTheBook.ogg")
const NEXT_PAGE_FOR_BOOK = preload("res://Audio/Sound/NextPageForBook.ogg")
const CLOSE_THE_BOOK = preload("res://Audio/Sound/CloseTheBook.ogg")
@onready var wrong_answer_label: RichTextLabel = $PaperTexture/WrongContainer/WrongAnswerLabel

const COMPLETE_MATH_EQUATION_SETTINGS = preload('res://visuals/label_settings/complete_math_equation_settings.tres')

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
	$HWSound.stream = NEXT_PAGE_FOR_BOOK
	$HWSound.play()
	current_problem.text = homework_manager.current_problem.text
	
	for child in solved_problems.get_children():
		child.queue_free()
	
	for problem in homework_manager.solved_problems:
		var label = Label.new()
		label.text = problem
		label.theme = homework_theme
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.label_settings = COMPLETE_MATH_EQUATION_SETTINGS
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
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
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
	wrong_answer_label.show()

func _on_wrong_answer_timer_timeout() -> void:
	buttons_disabled = false
	set_buttons_disabled(false)
	
	# Удаляем уведомление
	wrong_answer_label.hide()


func _on_homework_completed() -> void:
	$HWSound.stream = CLOSE_THE_BOOK
	$HWSound.play()
	game_completed.emit() 
