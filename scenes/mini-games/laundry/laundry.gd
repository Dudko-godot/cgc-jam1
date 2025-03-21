extends Control

signal game_completed
@warning_ignore('unused_signal')
signal game_cancelled

const LaundryUnit = preload("res://scenes/mini-games/laundry/laundry_unit.tscn")
var current_score = 0
var required_score = 4  # Соответствует количеству белья в корзине
var current_unit = null


@onready var laundry: AudioStreamPlayer = $Laundry

@export var types : Array[String] = []
@export var textures : Array[Texture] = []
@export var laundry_basket : Control

func _ready():
	setup_game()
	laundry_basket.clothes_taken.connect(_on_clothes_taken)

func setup_game():
	current_score = 0
	laundry_basket.reset()
	if current_unit:
		current_unit.queue_free()
		current_unit = null

@warning_ignore('unused_parameter')
func _on_clothes_taken(clothes_type: String = types[current_score]):
	if current_unit:
		current_unit.queue_free()
		laundry_basket.item_removed()  # Сбрасываем флаг, если предыдущий предмет удален
	
	current_unit = LaundryUnit.instantiate()
	add_child(current_unit)
	#current_unit.set_clothes_type(clothes_type)
	current_unit.set_laundry_unit(textures[current_score])
	
	# Устанавливаем позицию над корзиной
	var basket = laundry_basket
	current_unit.global_position = basket.global_position - Vector2(0, 150)
	
	# Подключаем сигналы
	current_unit.hung_on_line.connect(_on_clothes_hung)

func _on_clothes_hung():
	laundry.play()
	laundry_basket.item_hung()  # Сообщаем корзине, что предмет повешен
	current_score += 1
	
	if current_score >= required_score:
		#print('Laundry hung')
		game_completed.emit()
	elif not laundry_basket.is_empty():
		current_unit = null  # Очищаем ссылку на текущий предмет
