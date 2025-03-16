extends Control

@export var fade_duration : float = 0.5

@export var loader : BackgroundLoader
@export var label : RichTextLabel

 
func _ready() -> void:
	if loader.is_loading_finished :
		_on_loading_finished()
		return
		
	loader.loading_finished.connect(_on_loading_finished, CONNECT_ONE_SHOT)


func _on_loading_finished() -> void:
	var _tween : Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	_tween.tween_property(label, 'modulate:a', 0.0, fade_duration)
	_tween.tween_callback(_to_main_menu)


func _to_main_menu() -> void:
	get_tree().change_scene_to_packed(loader.target_resource)
