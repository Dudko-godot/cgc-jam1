extends Node

var current_problem := {}
var solved_problems := []
const PROBLEMS_TO_COMPLETE := 4
var rng := RandomNumberGenerator.new()

signal homework_completed

func _ready() -> void:
	rng.randomize()
	generate_new_problem()

func generate_new_problem() -> void:
	if solved_problems.size() >= PROBLEMS_TO_COMPLETE:
		homework_completed.emit()
		return
		
	var num1: int
	var num2: int
	var operations: Array[String] = ["+", "-", "*"]
	var operation: String = operations[rng.randi() % operations.size()]
	
	match operation:
		"+":
			num1 = rng.randi_range(1, 50)
			num2 = rng.randi_range(1, 99 - num1)
		"-":
			num1 = rng.randi_range(1, 99)
			num2 = rng.randi_range(1, num1)
		"*":
			num1 = rng.randi_range(1, 9)
			num2 = rng.randi_range(1, 9)
	
	var correct_answer: int
	match operation:
		"+": correct_answer = num1 + num2
		"-": correct_answer = num1 - num2
		"*": correct_answer = num1 * num2
	
	current_problem = {
		"text": str(num1) + " " + operation + " " + str(num2) + " = ?",
		"answer": correct_answer
	}
	
	var answers := [correct_answer]
	while answers.size() < 4:
		var wrong: int
		match operation:
			"+", "-":
				wrong = correct_answer + rng.randi_range(1, 5) * (rng.randi_range(0, 1) * 2 - 1)
			"*":
				wrong = correct_answer + rng.randi_range(1, 3) * (rng.randi_range(0, 1) * 2 - 1)
		
		
		if wrong > 0 and wrong < 100 and not wrong in answers:
			answers.append(wrong)
	

	answers.shuffle()
	current_problem["options"] = answers

func check_answer(selected: int) -> bool:
	if selected == current_problem.answer:
		solved_problems.append(current_problem.text + " = " + str(current_problem.answer))
		generate_new_problem()
		return true
	return false 
