extends Control

signal game_completed
@warning_ignore('unused_signal')
signal game_cancelled

# Параметры игры
var plants: Array[Node2D] = []
var plants_watered: int = 0
var total_plants: int = 0

# Ссылки на узлы
@onready var plants_container: Node2D = $PlantsContainer
@onready var watering_can: RigidBody2D = $WateringCan
@onready var water_tap: Node2D = $WaterTap
@onready var water_level_ui: Control = $WaterLevelUI

func _ready() -> void:
	randomize()
	_initialize_plants()
	_connect_signals()

# Инициализирует растения
func _initialize_plants() -> void:
	if plants_container:
		var plant_nodes: Array = plants_container.get_children().filter(func(node): return node.is_in_group("plants"))
		plants.clear()
		
		for node in plant_nodes:
			if node is Node2D:
				plants.append(node)
		
		total_plants = plants.size()
		
		for i in range(plants.size()):
			var plant: Node2D = plants[i]
			
			var water_types = [2.0, 3.0, 4.0, 5.0]
			var water_requirement: float = water_types[randi() % water_types.size()]
			plant.set_required_water(water_requirement)

# Подключает сигналы
func _connect_signals() -> void:
	#if watering_can:
		#watering_can.water_level_changed.connect(_on_water_level_changed)
	
	for plant in plants:
		plant.watering_completed.connect(_on_plant_watering_completed)

## Обработчик изменения уровня воды
#func _on_water_level_changed(current_water: float, max_water: float) -> void:
	#if water_level_ui:
		#water_level_ui.update_level(current_water, max_water)

# Обработчик завершения полива растения
func _on_plant_watering_completed() -> void:
	plants_watered += 1
	
	if plants_watered >= total_plants:
		await get_tree().create_timer(1.0).timeout
		game_completed.emit()


## Обработчик нажатия кнопки отмены
#func _on_cancel_button_pressed() -> void:
	#game_cancelled.emit()
