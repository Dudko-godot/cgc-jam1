extends Control

@export var main_menu_scene_name : String = ''
@export var fade_duration : float = 0.5

@export var loader : BackgroundLoader
@export var label : RichTextLabel

 
func _ready() -> void:
	if SceneManager.is_everything_loaded():
		_on_loading_finished()
		return
		
	SceneManager.loaded_scene.connect(_on_manager_scene_loaded)
	SceneManager.full_loading_complete.connect(_on_loading_finished)

func _on_manager_scene_loaded(parameter_name_ : String) -> void:
	if main_menu_scene_name != parameter_name_ : return
	
	SceneManager.loaded_scene.disconnect(_on_manager_scene_loaded)
	_on_loading_finished()

func _process(delta: float) -> void:
	if SceneManager.is_everything_loaded() : _on_loading_finished

func _on_loading_finished() -> void:
	var _tween : Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	_tween.tween_property(label, 'modulate:a', 0.0, fade_duration)
	_tween.tween_callback(_to_main_menu)


func _to_main_menu() -> void:
	get_tree().change_scene_to_packed(SceneManager.main_menu)
