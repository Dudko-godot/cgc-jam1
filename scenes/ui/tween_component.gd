extends Node

@export var actor : CanvasItem

@export_range(0.0, 2.0, 0.1) var duration : float = 0.5
@export_range(0.0, 2.0, 0.1) var delay : float = 0.2

func _ready() -> void:
	actor.modulate.a = 0.0
	
	var tween : Tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(actor, 'modulate:a', 1.0, duration).set_delay(delay)
