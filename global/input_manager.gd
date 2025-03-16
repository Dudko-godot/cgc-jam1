extends Node

# Сигналы для движения
signal move_input(direction)

# Сигналы для действий
signal interact_pressed
signal interact_released

# Флаг для блокировки ввода
var input_enabled = true

func _process(_delta):
	if input_enabled:
		# Обработка движения
		var move_direction = Vector2.ZERO
		move_direction.x = Input.get_axis("move_left", "move_right")
		move_direction.y = Input.get_axis("move_up", "move_down")
		
		if move_direction != Vector2.ZERO:
			move_input.emit(move_direction.normalized())

func _input(event):
	if not input_enabled:
		return
		
	# Обработка действия взаимодействия
	if event.is_action_pressed("interact"):
		interact_pressed.emit()
	elif event.is_action_released("interact"):
		interact_released.emit()

# Методы для включения/отключения ввода
func enable_input():
	input_enabled = true
	
func disable_input():
	input_enabled = false
