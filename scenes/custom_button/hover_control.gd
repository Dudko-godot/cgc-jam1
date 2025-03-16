extends Node

@export var button : CustomButton
@export var label : Label
@export var tween_component : TweenComponent

const MULT_SIZE_HOVER : float = 1.15
const MULT_SIZE_PRESSED: float = 0.9

const DEFAULT_DURATION : float = 0.15

#var font_size_default : int = 12

func _ready() -> void:
	button.got_hovered.connect(_on_hovered)
	button.got_unhovered.connect(_to_default)

	button.button_down.connect(_to_pressed)
	button.button_up.connect(_on_button_up)
	
	_to_default.call_deferred()


func _to_hovered() -> void:
	_tween_size(floor(float(button.font_size) * MULT_SIZE_HOVER))
	#label.label_settings.font_size = 


func _to_default() -> void:
	_tween_size(floor(button.font_size))
	#label.label_settings.font_size = floor(button.font_size)


func _to_pressed() -> void:
	_tween_size(floor(float(button.font_size) * MULT_SIZE_PRESSED), 0.0)
	#label.label_settings.font_size = floor(float(button.font_size) * MULT_SIZE_PRESSED)


func _tween_size(size_ : int, duration_ : float = DEFAULT_DURATION) -> void:
	tween_component.refresh_tween()
	
	tween_component.tween.tween_property(label, 'label_settings:font_size', size_, duration_)


func _on_button_up() -> void:
	if button.hovered:
		_to_hovered()
	else:
		_to_default()

func _on_hovered() -> void:
	if button.button_pressed : return
	_to_hovered()
