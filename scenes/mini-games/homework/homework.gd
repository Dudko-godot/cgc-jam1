extends Control

signal game_completed
signal game_cancelled

@onready var solved_problems = $Paper/MarginContainer/VBoxContainer/SolvedProblems
@onready var current_problem = $Paper/MarginContainer/VBoxContainer/CurrentProblem
@onready var answer_options = $AnswerOptions
@onready var homework_theme = preload("res://scenes/mini-games/homework/homework_theme.tres")

var homework_manager: Node
var problems_to_complete = 4

func _ready() -> void:
	homework_manager = Node.new()
	homework_manager.set_script(load("res://scenes/mini-games/homework/homework_manager.gd"))
	add_child(homework_manager)
	
	homework_manager.homework_completed.connect(_on_homework_completed)
	current_problem.theme = homework_theme
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
	if homework_manager.check_answer(answer):
		update_display()
		create_answer_buttons()

func _on_homework_completed() -> void:
	emit_signal("game_completed") 
