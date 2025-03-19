extends Control

enum MODE {
	BASE,
	HEIGHT_CONTROLS_WIDTH,
	WIDTH_CONTROLS_HEIGHT
}

enum VALIGN {
	TOP,
	CENTER,
	BOTTOM
}

enum HALIGN {
	LEFT,
	CENTER,
	RIGHT
}
## When resized, scales the target as well

@export_group('Internal References')
@export var target : CanvasItem
@export_group('Settings')
@export var mode : MODE = MODE.BASE
#@export var ratio : float = 0.0

@export var vertical_alignment : VALIGN = VALIGN.TOP
@export var horizontal_alignment : HALIGN = HALIGN.LEFT

@export var default_size : Vector2 = Vector2.ZERO
var target_default_scale : Vector2 = Vector2.ZERO


func _ready() -> void:
	await get_tree().process_frame
	#ratio = target.texture.get_height / target.texture.get_width
	target_default_scale = target.scale	
	resized.connect(_on_resized, CONNECT_DEFERRED)
	_on_resized.call_deferred()


func _on_resized() -> void:
	match mode:
		MODE.BASE:
			_resized_base()
		MODE.HEIGHT_CONTROLS_WIDTH:
			_resized_height_controls_width()
		MODE.WIDTH_CONTROLS_HEIGHT:
			_resized_width_controls_height()



func _resized_base() -> void:
	target.scale.x = (float(size.abs().x) / default_size.x) * target_default_scale.x
	target.scale.y = (float(size.abs().y) / default_size.y) * target_default_scale.y


func _resized_height_controls_width() -> void:
	var _ratio = float(size.abs().y) / default_size.y
	
	target.scale.y = _ratio * target_default_scale.y
	target.scale.x = _ratio * target_default_scale.x
	
	_reposition_vertical()
	_reposition_horizontal()

func _resized_width_controls_height() -> void:
	var _ratio = float(size.abs().x) / default_size.x
	
	target.scale.y = _ratio * target_default_scale.y
	target.scale.x = _ratio * target_default_scale.x
	
	_reposition_vertical()
	_reposition_horizontal()


func _reposition_vertical(ratio_ : float = 0.0) -> void:
	var _offset : float = (1.0 - ratio_) * default_size.y
	print(_offset)
	match vertical_alignment:
		VALIGN.TOP:
			pass
		VALIGN.CENTER:
			target.position.y = 0.5 * _offset
		VALIGN.BOTTOM:
			target.position.y = _offset


func _reposition_horizontal(ratio_ : float = 0.0) -> void:
	var _offset : float = (1.0 - ratio_) * default_size.x
	print(_offset)
	match horizontal_alignment:
		HALIGN.LEFT:
			pass
		HALIGN.CENTER:
			target.position.x = 0.5 * _offset
		HALIGN.RIGHT:
			target.position.x = _offset
