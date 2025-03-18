extends TextureRect

signal dragging_started
signal dragging_ended
signal hung_on_line

var dragging = false
var drag_offset = Vector2()
var original_position = Vector2()
var clothes_type: String = ""
var is_hung = false

@onready var shadow_better: TextureRect = $ShadowBetter

func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS
	original_position = global_position
	gui_input.connect(_on_gui_input)
	print("LaundryUnit: Created at position ", global_position)  # Отладочная информация

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed and not is_hung:
				dragging = true
				drag_offset = global_position - get_global_mouse_position()
				emit_signal("dragging_started")
				print("LaundryUnit: Started dragging")  # Отладочная информация
			elif dragging:
				dragging = false
				emit_signal("dragging_ended")
				_check_if_hung()
				print("LaundryUnit: Stopped dragging")  # Отладочная информация

func _process(_delta):
	if dragging:
		global_position = get_global_mouse_position() + drag_offset

func set_clothes_type(type: String):
	clothes_type = type
	# Здесь можно добавить логику изменения текстуры в зависимости от типа

func set_laundry_unit(texture_ : Texture2D) -> void:
	texture = texture_
	shadow_better.texture = texture_
	
func _check_if_hung():
	if is_hung:
		return
		
	print("LaundryUnit: Checking if can be hung")  # Отладочная информация
	
	# Проверка, находится ли предмет над веревкой
	var clothesline = get_parent().find_child("Clothesline", true, false)
	if not clothesline:
		print("LaundryUnit: Clothesline not found in parent, searching in root")  # Отладочная информация
		clothesline = get_tree().get_root().find_child("Clothesline", true, false)
	
	if clothesline:
		print("LaundryUnit: Found clothesline")  # Отладочная информация
		var slots = clothesline.get_node("ClothesSlots")
		if slots:
			print("LaundryUnit: Found slots container with ", slots.get_child_count(), " slots")  # Отладочная информация
			var closest_slot = null
			var min_distance = 100000
			
			# Ищем ближайший свободный слот
			for slot in slots.get_children():
				if slot.get_child_count() <= 1:  # Учитываем, что в слоте есть маркер
					var distance = global_position.distance_to(slot.global_position)
					print("LaundryUnit: Slot distance ", distance)  # Отладочная информация
					if distance < min_distance:
						min_distance = distance
						closest_slot = slot
			
			# Если нашли подходящий слот и достаточно близко к нему
			if closest_slot and min_distance < 150:  # Увеличил дистанцию для лучшего захвата
				print("LaundryUnit: Found suitable slot at distance ", min_distance)  # Отладочная информация
				# Перемещаем белье в слот
				var current_parent = get_parent()
				current_parent.remove_child(self)
				closest_slot.add_child(self)
				size = Vector2(100, 100)  # Устанавливаем размер
				position = Vector2(0, 00)  # Размещаем над линией
				is_hung = true
				emit_signal("hung_on_line")
				print("LaundryUnit: Successfully hung on line")  # Отладочная информация
			else:
				print("LaundryUnit: No suitable slot found, returning to original position")  # Отладочная информация
				# Возвращаем на исходную позицию
				global_position = original_position
		else:
			print("LaundryUnit: No slots container found")  # Отладочная информация
	else:
		print("LaundryUnit: No clothesline found")  # Отладочная информация

func reset_position():
	if not is_hung:
		global_position = original_position 
