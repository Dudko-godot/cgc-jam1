extends Control

signal game_completed
signal game_cancelled

# Константы для настройки игры
const MIN_TOYS_TO_WIN = 5   # Минимальное количество игрушек для победы
const GAME_DURATION = 60    # Продолжительность игры в секундах
const TOY_SCENE = preload("res://scenes/mini-games/cleanup_toys/toy.tscn")
const INITIAL_TOYS = 5      # Начальное количество игрушек

# Границы спавна игрушек
const SPAWN_MARGIN = 50     # Отступ от краев
const SPAWN_AREA = {
	"left": SPAWN_MARGIN,            # Левая граница
	"right": 800 - SPAWN_MARGIN,     # Правая граница
	"top": SPAWN_MARGIN,             # Верхняя граница
	"bottom": 400                    # Нижняя граница (не доходя до корзины)
}

# Переменные состояния игры
var toys_collected = 0
var time_remaining = GAME_DURATION

@onready var basket = $Basket

func _ready():
	# Инициализация игры
	setup_game()
	# Подключаем сигналы корзины
	basket.body_entered.connect(_on_basket_body_entered)

func _process(delta):
	if time_remaining > 0:
		time_remaining -= delta
		if time_remaining <= 0:
			_on_game_over()

func setup_game():
	# Сброс состояния игры
	toys_collected = 0
	time_remaining = GAME_DURATION
	
	# Создаем игрушки в случайных позициях
	for i in range(INITIAL_TOYS):
		spawn_toy()

func spawn_toy():
	var toy = TOY_SCENE.instantiate()
	add_child(toy)
	
	# Устанавливаем случайную позицию для игрушки в пределах игровой области
	var x = randf_range(SPAWN_AREA.left, SPAWN_AREA.right)
	var y = randf_range(SPAWN_AREA.top, SPAWN_AREA.bottom)
	toy.position = Vector2(x, y)  # Используем локальные координаты

func _on_game_over():
	if toys_collected >= MIN_TOYS_TO_WIN:
		emit_signal("game_completed")
	else:
		emit_signal("game_cancelled")

func _on_toy_collected():
	toys_collected += 1
	if toys_collected >= MIN_TOYS_TO_WIN:
		emit_signal("game_completed")

func _on_basket_body_entered(body: Node2D):
	if body.is_in_group("toy"):
		_on_toy_collected()
		body.queue_free() # Удаляем игрушку после попадания в корзину 
