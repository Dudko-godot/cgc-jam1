extends TextureRect

signal game_completed
signal game_cancelled

static var any_plate_washing := false

var clicks := 0
var is_washing := false
var is_clean := false
var original_parent: Node
var original_index: int

const ANGLE_AMP : int = 180

@onready var dirty_texture = preload('res://visuals/minigames/washing_dishes/plate_dirty.png')
@onready var semi_clean_texture = preload('res://visuals/minigames/washing_dishes/plate_semi.png')
@onready var clean_texture = preload('res://visuals/minigames/washing_dishes/plate_clean.png')
@onready var extrusion: MarginContainer = $Extrusion


func _ready():
	mouse_filter = Control.MOUSE_FILTER_STOP
	#custom_minimum_size.y = 0.5 * size.x
	gui_input.connect(_on_gui_input)

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Проверяем, что тарелка не чистая и не в контейнере чистых тарелок
		var in_clean_container = get_parent().name == "CleanPlatesContainer"
		if not is_washing and not any_plate_washing and not in_clean_container and not is_clean:
			start_washing()
		elif is_washing:
			wash()

func start_washing():

	extrusion.queue_free()
	is_washing = true
	any_plate_washing = true

	original_parent = get_parent()
	original_index = get_index()
	
	var washing_position = get_parent().get_parent().get_node("WashingPosition")
	if washing_position:
		reparent(washing_position)
		# Устанавливаем размер для центральной позиции
		custom_minimum_size = Vector2(180, 180)  # Делаем тарелку немного больше при мытье

func wash():
	clicks += 1
	if clicks == 1:
		texture = semi_clean_texture
	elif clicks == 2:
		texture = clean_texture
		finish_washing()

func finish_washing():
	is_washing = false
	any_plate_washing = false
	clicks = 0
	is_clean = true
	
	custom_minimum_size = Vector2(164, 164)
	
	var clean_container = get_parent().get_parent().get_node("CleanPlatesContainer")
	if clean_container:
		reparent(clean_container)
		
	# Проверяем, все ли тарелки чистые
	var sink = get_parent().get_parent()
	sink.check_all_plates_clean()
