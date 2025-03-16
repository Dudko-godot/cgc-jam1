extends TextureButton

signal clothes_taken(clothes_type: String)

var fill_levels = {
	100: preload("res://scenes/mini-games/laundry/test_box100.png"),
	75: preload("res://scenes/mini-games/laundry/test_box75.png"),
	50: preload("res://scenes/mini-games/laundry/test_box50.png"),
	25: preload("res://scenes/mini-games/laundry/test_box25.png"),
	0: preload("res://scenes/mini-games/laundry/test_box2.png")
}

var current_fill = 100
var clothes_remaining = 4  # Количество предметов белья в корзине
var item_in_hand = false  # Флаг, указывающий, что предмет уже взят

func _ready():
	pressed.connect(_on_basket_pressed)
	update_texture()

func _on_basket_pressed():
	# Проверяем, что в корзине есть белье и нет предмета в руках
	if clothes_remaining > 0 and not item_in_hand:
		clothes_remaining -= 1
		current_fill = (clothes_remaining * 100) / 4  # 4 - максимальное количество предметов
		update_texture()
		
		# Выбираем случайный тип белья
		var available_types = ["shirt", "pants", "socks", "towel"]
		var random_type = available_types[randi() % available_types.size()]
		
		# Устанавливаем флаг, что предмет взят
		item_in_hand = true
		
		emit_signal("clothes_taken", random_type)

func update_texture():
	# Находим ближайший уровень заполнения
	var levels = fill_levels.keys()
	var closest_fill = levels[0]
	
	for level in levels:
		if abs(level - current_fill) < abs(closest_fill - current_fill):
			closest_fill = level
	
	texture_normal = fill_levels[closest_fill]

func is_empty() -> bool:
	return clothes_remaining <= 0

# Вызывается, когда предмет повешен на веревку
func item_hung():
	item_in_hand = false

# Вызывается, когда предмет удален (например, при отмене игры)
func item_removed():
	item_in_hand = false

func reset():
	clothes_remaining = 4
	current_fill = 100
	item_in_hand = false
	update_texture() 
