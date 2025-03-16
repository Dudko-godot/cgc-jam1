extends Camera2D

@export_range(0.2, 5.0, 0.1) var starting_zoom : float = 0.5
@export_range(0.0, 4.0, 0.1) var starting_zoom_tween_duration : float = 1.5

func _ready() -> void:
	zoom = Vector2(starting_zoom, starting_zoom)
	_tween_zoom(1.0, starting_zoom_tween_duration, Tween.EASE_IN_OUT, Tween.TRANS_QUART)


func _tween_zoom(	level_ : float,
					duration_ : float,
					ease_ : Tween.EaseType = Tween.EASE_IN_OUT,
					trans_ : Tween.TransitionType = Tween.TRANS_SINE) -> void:
	var tween : Tween = create_tween().set_ease(ease_).set_trans(trans_)
	
	
	tween.tween_property(self, 'zoom', Vector2(level_, level_), duration_)
