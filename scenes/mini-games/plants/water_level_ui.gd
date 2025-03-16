extends Control

# Ссылки на узлы
@onready var progress_bar: ProgressBar = $Panel/ProgressBar
@onready var water_label: Label = $Panel/Label

# Параметры UI
var current_water: float = 0.0
var max_water: float = 10.0

# Цвета для прогресс-бара
const COLOR_LOW_WATER: Color = Color(0.5, 0.7, 1.0)
const COLOR_NORMAL_WATER: Color = Color(0.0, 0.47, 1.0)

func _ready() -> void:
	# Инициализация UI при запуске
	update_ui()

# Обновляет уровень воды
func update_level(current: float, maximum: float) -> void:
	current_water = current
	max_water = maximum
	update_ui()

# Обновляет все элементы UI
func update_ui() -> void:
	if not progress_bar:
		return
		
	# Обновляем прогресс-бар
	progress_bar.max_value = max_water
	progress_bar.value = current_water
	
	# Обновляем текст метки
	if water_label:
		water_label.text = "Вода: " + str(int(current_water)) + "/" + str(int(max_water))
	
	# Меняем цвет в зависимости от уровня воды
	update_progress_color(current_water < max_water * 0.3)

# Обновляет цвет прогресс-бара
func update_progress_color(is_low_water: bool) -> void:
	var style_box = progress_bar.get("theme_override_styles/fill")
	if style_box:
		style_box.bg_color = COLOR_LOW_WATER if is_low_water else COLOR_NORMAL_WATER
