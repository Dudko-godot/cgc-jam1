extends Node

@export var actor : CanvasItem
@export var panel : PanelContainer

@export_range(0.0, 2.0, 0.1) var duration : float = 0.5
@export_range(0.0, 2.0, 0.1) var delay : float = 0.2

func _ready() -> void:
	_appear_slide()
	#_appear_opacity()

func _appear_slide() -> void:
	actor.position.x = -1.5 * panel.size.x
	actor.rotation = deg_to_rad(20)
	var tween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(actor, 'position:x', 0.0, duration).set_delay(delay)
	tween.parallel().tween_property(actor, 'rotation', 0.0, duration).set_delay(delay)


func _apear_margin() -> void:
	#actor.add_theme_constant_override("margin_top", panel.size.y)
	
	var tween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_method(_set_margin, panel.size.y, 0, duration).set_delay(delay)
	
	
func _appear_opacity() -> void:
	actor.modulate.a = 0.0
	
	var tween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(actor, 'modulate:a', 1.0, duration).set_delay(delay)


func _set_margin(value_ : int) -> void:
	actor.add_theme_constant_override("margin_top", value_)
