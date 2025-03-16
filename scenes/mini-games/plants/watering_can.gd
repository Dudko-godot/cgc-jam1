extends RigidBody2D

signal water_level_changed(current_water: float, max_water: float)

# ======== НАСТРОЙКИ ФИЗИКИ И ПЕРЕТАСКИВАНИЯ ========
# Параметры движения и притяжения
var attraction_force: float = 1000.0  # Сила притяжения к курсору
var force_distance_scale: float = 5.0  # Масштаб увеличения силы с расстоянием
var force_max_multiplier: float = 5.0  # Максимальный множитель силы
var central_force_multiplier: float = 1.0  # Множитель центральной силы
var drag_gravity_scale: float = 0.3  # Гравитация при перетаскивании
var drag_linear_damp: float = 5.0  # Затухание при перетаскивании
var normal_linear_damp: float = 5.0  # Затухание в обычном состоянии
var grab_radius: float = 50.0  # Радиус для захвата лейки

# Параметры стабилизации вращения
var rotation_damp_factor: float = 2.5  # Затухание вращения
var custom_angular_damp: float = 8.0  # Затухание углового движения при перетаскивании
var normal_angular_damp_value: float = 4.0  # Затухание углового движения в обычном состоянии
var upright_force: float = 1.5  # Сила выравнивания

# ======== ПАРАМЕТРЫ ЛЕЙКИ И ПОЛИВА ========
var max_water: float = 10.0
var current_water: float = 0.0
var watering_rate: float = 2.5  # Скорость полива
var filling_rate: float = 2.0 # Cкорость наполнения
var is_watering: bool = false
var current_plant: Node2D = null
var is_near_tap: bool = false
var spout_node_name: String = "SpoutCollider"

# Параметры потери воды при наклоне
var tilt_water_loss_enabled: bool = true
var tilt_water_loss_threshold: float = 0.6  # Порог наклона (в радианах)
var tilt_water_loss_rate: float = 1.0 # Базовая скорость потери
var tilt_water_loss_max_rate: float = 4.0  # Максимальная скорость потери

# Параметры перетаскивания
var dragging: bool = false
var drag_start: Vector2 = Vector2()
var last_position: Vector2 = Vector2()
var velocity_threshold: float = 200.0  # Порог скорости для проливания

# Параметры зоны притяжения
var attraction_point: Vector2 = Vector2()  # Точка притяжения (курсор)
var local_grab_point: Vector2 = Vector2()  # Точка захвата на лейке

# Визуальные элементы
var grab_point: ColorRect = null

func _ready() -> void:
	initialize()
	
func initialize() -> void:
	# Базовая настройка
	add_to_group("watering_can")
	setup_physics()
	last_position = global_position
	water_level_changed.emit(current_water, max_water)
	
	# Инициализация окружения
	_create_visual_elements()
	_connect_signals()

func setup_physics() -> void:
	gravity_scale = 1.0
	mass = 2.0
	linear_damp = normal_linear_damp
	angular_damp = normal_angular_damp_value

# Создаем индикатор точки захвата
func _create_visual_elements() -> void:
	grab_point = ColorRect.new()
	grab_point.name = "GrabPoint"
	grab_point.size = Vector2(10, 10)
	grab_point.color = Color(1, 0, 0, 0.5)  # Полупрозрачный красный
	grab_point.visible = false
	add_child(grab_point)

# Подключаем сигналы коллизий для носика лейки и основного тела
func _connect_signals() -> void:
	# Подключаем сигналы для основного тела лейки
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	# Проверяем наличие носика лейки
	if has_node(spout_node_name) and get_node(spout_node_name) is Area2D:
		var spout: Area2D = get_node(spout_node_name)
		spout.body_entered.connect(_on_spout_body_entered)
		spout.body_exited.connect(_on_spout_body_exited)
		spout.area_entered.connect(_on_spout_area_entered)
		spout.area_exited.connect(_on_spout_area_exited)

func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if dragging:
		apply_attraction_force(state)

func apply_attraction_force(state: PhysicsDirectBodyState2D) -> void:
	# Вычисляем вектор от лейки к точке притяжения
	var to_mouse: Vector2 = attraction_point - global_position
	var distance: float = to_mouse.length()
	
	# Если расстояние не нулевое, применяем силу
	if distance > 0:
		# Нормализуем вектор направления
		var direction: Vector2 = to_mouse / distance
		
		# Вычисляем силу притяжения (увеличиваем силу с расстоянием для лучшего контроля)
		var force_magnitude: float = attraction_force
		if distance > 10.0:
			force_magnitude *= (distance / force_distance_scale)  # Увеличиваем силу с расстоянием
		
		# Ограничиваем максимальную силу
		force_magnitude = min(force_magnitude, attraction_force * force_max_multiplier)
		
		# Применяем силу к точке захвата
		var grab_point_global: Vector2 = global_position + local_grab_point.rotated(rotation)
		var offset: Vector2 = grab_point_global - global_position
		
		# Применяем силу с учетом смещения от центра
		state.apply_force(direction * force_magnitude, offset)
		
		# Сильное затухание вращения для стабильности
		state.apply_torque_impulse(-state.angular_velocity * rotation_damp_factor)
		
		# Если лейка слишком далеко от курсора, добавляем дополнительную силу к центру масс
		if distance > 50.0:
			state.apply_central_force(direction * force_magnitude * central_force_multiplier)
		
		# Добавляем силу, возвращающую лейку в вертикальное положение
		if upright_force > 0:
			# Вычисляем текущий угол наклона от вертикали
			var current_angle: float = fmod(rotation + PI * 2, PI * 2)
			if current_angle > PI:
				current_angle -= PI * 2
			
			# Применяем силу, пропорциональную углу наклона
			state.apply_torque(-current_angle * upright_force)

func _process(delta: float) -> void:
	handle_water_loss(delta)

func handle_water_loss(delta: float) -> void:
	# Проверяем наклон лейки для потери воды
	if tilt_water_loss_enabled and current_water > 0:
		# Получаем текущий угол наклона (0 = вертикально вверх, PI = вертикально вниз)
		var tilt_angle: float = abs(fmod(rotation + PI * 2, PI * 2))
		if tilt_angle > PI:
			tilt_angle = PI * 2 - tilt_angle
		
		# Если лейка наклонена больше порогового значения, теряем воду
		if tilt_angle > tilt_water_loss_threshold:
			# Вычисляем коэффициент потери воды в зависимости от наклона
			var tilt_factor: float = (tilt_angle - tilt_water_loss_threshold) / (PI - tilt_water_loss_threshold)
			tilt_factor = clamp(tilt_factor, 0.0, 1.0)
			
			# Вычисляем скорость потери воды
			var loss_rate: float = tilt_water_loss_rate + (tilt_water_loss_max_rate - tilt_water_loss_rate) * tilt_factor
			var water_loss: float = loss_rate * delta
			
			# Уменьшаем количество воды
			current_water = max(0.0, current_water - water_loss)
			water_level_changed.emit(current_water, max_water)

# Обработчики сигналов коллизий для носика лейки
func _on_spout_body_entered(_body: Node2D) -> void:
	pass

func _on_spout_body_exited(_body: Node2D) -> void:
	pass

func _on_spout_area_entered(area: Area2D) -> void:
	# Проверяем, является ли область зоной полива растения
	var parent = area.get_parent()
	if parent and parent.is_in_group("plants") and area.name == "WaterArea":
		is_watering = true
		current_plant = parent

func _on_spout_area_exited(area: Area2D) -> void:
	# Проверяем, является ли область зоной полива растения
	var parent = area.get_parent()
	if parent and parent.is_in_group("plants") and parent == current_plant and area.name == "WaterArea":
		is_watering = false
		current_plant = null

# Обработка коллизий для основной коллизии лейки
func _on_body_entered(body: Node2D) -> void:
	# Проверяем, является ли тело краном
	if body.is_in_group("water_taps"):
		is_near_tap = true
		if body.has_method("set_watering_can"):
			body.set_watering_can(self)

func _on_body_exited(body: Node2D) -> void:
	# Проверяем, является ли тело краном
	if body.is_in_group("water_taps"):
		is_near_tap = false
		if body.has_method("clear_watering_can"):
			body.clear_watering_can()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		handle_mouse_input(event)
	elif event is InputEventMouseMotion and dragging:
		# Обновляем точку притяжения при движении мыши
		attraction_point = get_global_mouse_position()

func handle_mouse_input(event: InputEventMouseButton) -> void:
	if event.pressed:
		handle_mouse_press()
	else:
		handle_mouse_release()

func handle_mouse_press() -> void:
	# Проверяем, кликнули ли по лейке
	var mouse_pos: Vector2 = get_global_mouse_position()
	
	# Проверка расстояния для определения клика
	if (mouse_pos - global_position).length() < grab_radius:
		start_dragging(mouse_pos)

func start_dragging(mouse_pos: Vector2) -> void:
	# Начинаем перетаскивание
	dragging = true
	drag_start = mouse_pos
	
	# Запоминаем локальную точку захвата
	local_grab_point = to_local(mouse_pos)
	
	# Устанавливаем начальную точку притяжения
	attraction_point = mouse_pos
	
	# Настраиваем физические параметры для перетаскивания
	gravity_scale = drag_gravity_scale
	linear_damp = drag_linear_damp
	angular_damp = custom_angular_damp
	
	# Показываем точку захвата
	if grab_point:
		grab_point.position = local_grab_point - Vector2(5, 5)  # Центрируем
		grab_point.visible = true

func handle_mouse_release() -> void:
	if dragging:
		end_dragging()

func end_dragging() -> void:
	dragging = false
	
	# Возвращаем нормальные физические параметры
	gravity_scale = 1.0
	linear_damp = normal_linear_damp
	angular_damp = normal_angular_damp_value
	
	# Скрываем точку захвата
	if grab_point:
		grab_point.visible = false

func fill_water(amount: float) -> void:
	var new_water: float = min(current_water + amount * filling_rate, max_water)
	current_water = new_water
	water_level_changed.emit(current_water, max_water)

func start_watering(plant: Node2D) -> void:
	is_watering = true
	current_plant = plant

func stop_watering() -> void:
	is_watering = false
	current_plant = null

# Методы для взаимодействия с краном
func set_near_tap(value: bool) -> void:
	is_near_tap = value

func _physics_process(delta: float) -> void:
	# Обработка наполнения лейки от крана
	handle_filling(delta)
	
	# Обработка полива растений
	handle_plant_watering(delta)

# Обрабатывает наполнение лейки от крана
func handle_filling(delta: float) -> void:
	# Если лейка находится рядом с краном, наполняем её водой
	if is_near_tap and current_water < max_water:
		var water_taps = get_tree().get_nodes_in_group("water_taps")
		for tap in water_taps:
			if tap.is_watering_can_near and tap.current_watering_can == self:
				fill_water(tap.water_flow_rate * delta)
				break

# Обрабатывает полив растений
func handle_plant_watering(delta: float) -> void:
	# Если лейка поливает растение через носик и растение не полностью полито, добавляем воду растению
	if is_watering and current_plant and current_water > 0 and not current_plant.is_fully_watered:
		var water_amount: float = watering_rate * delta
		if water_amount <= current_water:
			current_water -= water_amount
			current_plant.add_water(water_amount)
			water_level_changed.emit(current_water, max_water)
