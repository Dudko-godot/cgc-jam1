@tool
class_name CustomButton extends Button

@export var label : Label
@export var margin_container : MarginContainer
@export var automatic_minimal_size : bool = true
@export_range(8, 144, 1) var font_size : int = 36 : set = _set_font_size
#@export_range(8, 144, 1) var font_size_hover : int = 48
#@export_range(8, 144, 1) var font_size_hover : int = 48

signal got_hovered
signal got_unhovered

var hovered : bool = false : set = _set_hovered


func _set_hovered(hovered_ : bool) -> void:
	if hovered == hovered_ : return

	hovered = hovered_
	if hovered:
		got_hovered.emit()
	else:
		got_unhovered.emit()


func _ready() -> void:
	mouse_entered.connect(func() -> void : hovered = true)
	mouse_exited.connect(func() -> void : hovered = false)
	
	margin_container.resized.connect(_on_container_resized, CONNECT_DEFERRED)
	_on_container_resized.call_deferred(true)

func _set(property_name_ : StringName, value_ : Variant) -> bool:
	match property_name_:
		'text':
			text = value_
			label.text = text
	return false


func _set_font_size(size_ : int) -> void:
	if font_size == size_ : return
	font_size = size_
	
	if not label : return
	
	label.label_settings.font_size = font_size


func _on_container_resized(is_forced_ : bool = false) -> void:
	if not automatic_minimal_size : return
	if not (Engine.is_editor_hint() or is_forced_) : return
	self.custom_minimum_size = margin_container.size
