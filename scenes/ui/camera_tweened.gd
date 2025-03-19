class_name TweenedCamera extends Camera2D

var tween : Tween

const DEFAULT_EASE :  Tween.EaseType = Tween.EASE_IN_OUT
const DEFAULT_TRANS : Tween.TransitionType = Tween.TRANS_CUBIC

@export_range(0.2, 10.0, 0.01) var zoom_intro : float = 0.5
@export_range(0.2, 10.0, 0.01) var zoom_outro : float = 0.5
@export_range(0.2, 10.0, 0.01) var zoom_defeat : float = 0.5
@export_range(0.0, 2.0, 0.01) var duration_intro : float = 0.5
@export_range(0.0, 2.0, 0.01) var duration_outro : float = 0.5
@export_range(0.0, 2.0, 0.01) var duration_defeat : float = 0.5

signal started_outro

func _refresh_tween(
					ease_ : Tween.EaseType = DEFAULT_EASE,
					trans_ : Tween.TransitionType = DEFAULT_TRANS) -> void:
	if tween : tween.kill()
	
	tween = create_tween().set_ease(ease_).set_trans(trans_)


func _tween_intro() -> void:
	var _target_zoom : Vector2 = zoom
	zoom = Vector2(zoom_intro, zoom_intro)
	_refresh_tween()
	
	tween.tween_property(self, 'zoom', _target_zoom, duration_intro)


func _tween_victory() -> void:
	started_outro.emit()
	_refresh_tween(Tween.EASE_IN, Tween.TRANS_QUAD)
	
	tween.tween_property(self, 'zoom', Vector2(zoom_outro, zoom_outro), duration_outro)


func _tween_defeat() -> void:
	started_outro.emit()
	_refresh_tween(Tween.EASE_IN_OUT, Tween.TRANS_CIRC)
	tween.tween_property(self, 'zoom', Vector2(zoom_defeat, zoom_defeat), duration_defeat)
	tween.parallel().tween_property(self, 'rotation_degrees', 65, duration_defeat)
