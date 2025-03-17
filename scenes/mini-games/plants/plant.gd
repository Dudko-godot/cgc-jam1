extends Node2D

signal watered(current_water: float, required_water: float)
signal watering_completed

# Параметры растения
@export var required_water: float = 3.0  # Количество воды для полного полива (разное для разных растений)

# Цвета для прогресс-бара
const COLOR_NORMAL: Color = Color(0.0, 0.47, 1.0)  # Синий
const COLOR_FILLED: Color = Color(0.0, 0.8, 0.2)    # Зеленый
const COLOR_BACKGROUND: Color = Color(0.2, 0.2, 0.2)  # Серый

var current_water: float = 0.0
var watering_in_progress: bool = false
var is_fully_watered: bool = false  # Флаг полного полива

# Узлы
@onready var progress_bar: ProgressBar = $WaterProgressBar if has_node("WaterProgressBar") else null
@onready var water_label: Label = $WaterLabel if has_node("WaterLabel") else null
@onready var sprite: Sprite2D = $Sprite2D if has_node("Sprite2D") else null

# Стили для прогресс-бара
var bg_style: StyleBoxFlat = null
var fill_style: StyleBoxFlat = null

func _ready() -> void:
	add_to_group("plants")
	init_progress_bar()
	
	# Подключаем сигналы для зоны полива
	if has_node("WaterArea"):
		var water_area = get_node("WaterArea")
		water_area.body_entered.connect(_on_water_area_body_entered)
		water_area.body_exited.connect(_on_water_area_body_exited)
		water_area.area_entered.connect(_on_water_area_area_entered)
		water_area.area_exited.connect(_on_water_area_area_exited)

# Инициализация прогресс-бара и метки
func init_progress_bar() -> void:
	if progress_bar:
		progress_bar.max_value = required_water
		progress_bar.value = current_water
		
		# Инициализируем стили прогресс-бара
		setup_progress_bar_styles()
		update_progress_bar_color()
	
	update_water_label()

# Настраивает стили прогресс-бара (вызывается один раз при инициализации)
func setup_progress_bar_styles() -> void:
	if not progress_bar:
		return
	
	# Создаем стиль фона
	bg_style = StyleBoxFlat.new()
	bg_style.bg_color = COLOR_BACKGROUND
	bg_style.corner_radius_top_left = 4
	bg_style.corner_radius_top_right = 4
	bg_style.corner_radius_bottom_right = 4
	bg_style.corner_radius_bottom_left = 4
	progress_bar.set("theme_override_styles/background", bg_style)
	
	# Создаем стиль заполнения
	fill_style = StyleBoxFlat.new()
	fill_style.corner_radius_top_left = 4
	fill_style.corner_radius_top_right = 4
	fill_style.corner_radius_bottom_right = 4
	fill_style.corner_radius_bottom_left = 4
	progress_bar.set("theme_override_styles/fill", fill_style)

# Обновляет текст метки с информацией о воде
func update_water_label() -> void:
	if water_label:
		water_label.text = str(int(current_water)) + "/" + str(int(required_water))

# Устанавливает количество воды, необходимое для полного полива
func set_required_water(value: float) -> void:
	required_water = value
	if progress_bar:
		progress_bar.max_value = required_water
	update_water_label()

# Устанавливает спрайт растения
func set_sprite(sprite_path: String) -> void:
	if sprite and ResourceLoader.exists(sprite_path):
		sprite.texture = load(sprite_path)

# Добавляет воду к растению
func add_water(amount: float) -> void:
	
	if is_fully_watered:
		return
	
	# Добавляем воду (без множителя скорости)
	current_water = min(current_water + amount, required_water)
	
	# Обновляем прогресс-бар
	if progress_bar:
		progress_bar.value = current_water
		update_progress_bar_color()
	
	# Обновляем метку с информацией о воде
	update_water_label()
	
	# Отправляем сигнал об изменении уровня воды
	watered.emit(current_water, required_water)
	
	# Проверяем, достигли ли мы необходимого количества воды
	if current_water >= required_water and !is_fully_watered:
		is_fully_watered = true
		watering_completed.emit()
		update_progress_bar_color()

# Обработчик входа лейки в зону полива
func _on_water_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("watering_can"):
		watering_in_progress = true
		if body.has_method("start_watering"):
			body.start_watering(self)

# Обработчик выхода лейки из зоны полива
func _on_water_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("watering_can"):
		watering_in_progress = false
		if body.has_method("stop_watering"):
			body.stop_watering()

# Обработчик входа носика лейки в зону полива
func _on_water_area_area_entered(area: Area2D) -> void:
	$"../../ForPlant".play()
	if area.get_parent().is_in_group("watering_can") and area.name == "SpoutCollider":
		watering_in_progress = true
		if area.get_parent().has_method("start_watering"):
			area.get_parent().start_watering(self)

# Обработчик выхода носика лейки из зоны полива
func _on_water_area_area_exited(area: Area2D) -> void:
	$"../../ForPlant".stop()
	if area.get_parent().is_in_group("watering_can") and area.name == "SpoutCollider":
		watering_in_progress = false
		if area.get_parent().has_method("stop_watering"):
			area.get_parent().stop_watering()

# Обновляет цвет прогресс-бара в зависимости от заполнения
func update_progress_bar_color() -> void:
	if not progress_bar or not fill_style:
		return
	
	# Устанавливаем цвет в зависимости от состояния
	fill_style.bg_color = COLOR_FILLED if is_fully_watered else COLOR_NORMAL
