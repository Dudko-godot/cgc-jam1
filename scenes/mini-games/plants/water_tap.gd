extends Node2D

# Параметры крана
@export var water_flow_rate: float = 1.0  # Скорость подачи воды

var is_watering_can_near: bool = false
var current_watering_can: RigidBody2D = null

# Узлы
@onready var water_area: Area2D = $WaterArea if has_node("WaterArea") else null

func _ready() -> void:
	# Добавляем в группу для обнаружения
	add_to_group("water_taps")
	
	# Настройка области взаимодействия
	setup_water_area()

# Настройка области взаимодействия с водой
func setup_water_area() -> void:
	if water_area:
		water_area.body_entered.connect(_on_water_area_body_entered)
		water_area.body_exited.connect(_on_water_area_body_exited)
	else:
		push_error("Кран: WaterArea не найдена!")

# Обработчик входа лейки в зону крана
func _on_water_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("watering_can"):
		is_watering_can_near = true
		current_watering_can = body
		
		# Сообщаем лейке, что она рядом с краном
		if body.has_method("set_near_tap"):
			body.set_near_tap(true)

# Обработчик выхода лейки из зоны крана
func _on_water_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("watering_can") and body == current_watering_can:
		is_watering_can_near = false
		
		# Сообщаем лейке, что она больше не рядом с краном
		if body.has_method("set_near_tap"):
			body.set_near_tap(false)
		
		current_watering_can = null

# Устанавливает текущую лейку
func set_watering_can(can: RigidBody2D) -> void:
	current_watering_can = can
	is_watering_can_near = true

# Очищает текущую лейку
func clear_watering_can() -> void:
	current_watering_can = null
	is_watering_can_near = false
