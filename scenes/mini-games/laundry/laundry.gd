extends Control

signal game_completed
signal game_cancelled

const LaundryUnit = preload("res://scenes/mini-games/laundry/laundry_unit.tscn")
var current_score = 0
var required_score = 4  # Соответствует количеству белья в корзине
var current_unit = null

func _ready():
	setup_game()
	$BasketArea/LaundryBasket.clothes_taken.connect(_on_clothes_taken)

func setup_game():
	current_score = 0
	$BasketArea/LaundryBasket.reset()
	if current_unit:
		current_unit.queue_free()
		current_unit = null

func _on_clothes_taken(clothes_type: String):
	if current_unit:
		current_unit.queue_free()
		$BasketArea/LaundryBasket.item_removed()  # Сбрасываем флаг, если предыдущий предмет удален
	
	current_unit = LaundryUnit.instantiate()
	add_child(current_unit)
	current_unit.set_clothes_type(clothes_type)
	
	# Устанавливаем позицию над корзиной
	var basket = $BasketArea/LaundryBasket
	current_unit.global_position = basket.global_position - Vector2(0, 150)
	
	# Подключаем сигналы
	current_unit.hung_on_line.connect(_on_clothes_hung)

func _on_clothes_hung():
	$"Bel'e".play()
	$BasketArea/LaundryBasket.item_hung()  # Сообщаем корзине, что предмет повешен
	current_score += 1
	
	if current_score >= required_score:
		game_completed.emit
	elif not $BasketArea/LaundryBasket.is_empty():
		current_unit = null  # Очищаем ссылку на текущий предмет
