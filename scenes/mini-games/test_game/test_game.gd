extends Control

signal game_completed
signal game_cancelled

@onready var button1 = $ButtonsContainer/Button1
@onready var button2 = $ButtonsContainer/Button2
@onready var button3 = $ButtonsContainer/Button3
@onready var button4 = $ButtonsContainer/Button4

var correct_sequence = [1, 2, 3, 4]  # Порядок, в котором нужно нажимать
var current_index = 0

func _ready():
	# Настраиваем кнопки
	button1.text = "1"
	button2.text = "2"
	button3.text = "3"
	button4.text = "4"
	
	# Подключаем сигналы
	button1.connect("pressed", _on_button_pressed.bind(1))
	button2.connect("pressed", _on_button_pressed.bind(2))
	button3.connect("pressed", _on_button_pressed.bind(3))
	button4.connect("pressed", _on_button_pressed.bind(4))

func _on_button_pressed(button_value):
	# Проверяем, правильная ли кнопка нажата
	if correct_sequence[current_index] == button_value:
		current_index += 1
		
		if current_index >= correct_sequence.size():
			success_handler()
	else:
		fail_handler()

func success_handler():
	emit_signal("game_completed")

func fail_handler():
	# Ошибка: сбрасываем индекс
	current_index = 0
	emit_signal("game_cancelled") 
