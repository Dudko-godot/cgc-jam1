extends Area2D

@export var minigame_name: String = "test_game"
@export var prompt_text: String = "Нажмите E для запуска мини-игры"

var player_in_range = false
var label = null

func _ready():
	# Создаем метку для подсказки
	label = Label.new()
	label.text = prompt_text
	label.visible = false
	add_child(label)
	
	# Подключаем сигналы
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _input(event):
	# Проверяем нажатие клавиши E (ui_accept) или KEY_E
	if player_in_range and event.is_action_pressed("interact"):
		_start_minigame()

func _process(delta):
	# Обновляем позицию метки
	if label and label.visible:
		label.position = Vector2(-label.size.x / 2, -50)

func _on_body_entered(body):
	if body is CharacterBody2D:
		player_in_range = true
		label.visible = true

func _on_body_exited(body):
	if body is CharacterBody2D:
		player_in_range = false
		label.visible = false

func _start_minigame():
	# Пытаемся получить доступ к MiniGameManager
	var mini_game_manager = get_node_or_null("/root/MiniGameManager")
	
	if mini_game_manager == null:
		return
	
	# Проверяем, не активна ли уже мини-игра
	if mini_game_manager.is_minigame_active():
		return
	
	# Запускаем мини-игру
	mini_game_manager.start_minigame(minigame_name) 
