extends Control

const SLOTS_COUNT = 4

func _ready():
	
	# Создаем слоты для белья
	for i in range(SLOTS_COUNT):
		var slot = Control.new()
		slot.name = "Slot" + str(i)
		slot.custom_minimum_size = Vector2(100, 100)
		
		# Добавляем слот в контейнер
		$ClothesSlots.add_child(slot)
		
		# Добавляем визуальный индикатор слота
		var marker = ColorRect.new()
		marker.name = "Marker"
		marker.color = Color.GOLD#Color(0.5, 0.5, 0.5, 0.3)
		marker.custom_minimum_size = Vector2(14, 40)
		marker.position = Vector2(50, -20)  # Опускаем маркер ниже
		slot.add_child(marker)
	
	# Перемещаем контейнер со слотами ниже веревки
	
	$ClothesSlots.position.y += 60
	
	#print("Clothesline: Created ", SLOTS_COUNT, " slots with increased spacing")  # Отладочная информация
