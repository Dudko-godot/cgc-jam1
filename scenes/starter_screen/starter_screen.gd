extends Control

@export var game_title : String = ''

@export var fade_duration : float = 0.5

@export var loader : BackgroundLoader
@export var label : RichTextLabel


 
func _ready() -> void:
	DisplayServer.window_set_title(game_title)
	
	if SceneManager.is_everything_loaded:
		_on_loading_finished()
		return
		
	SceneManager.full_loading_complete.connect(_on_loading_finished)


func _process(delta: float) -> void:
	if SceneManager.is_everything_loaded : _on_loading_finished()

func _on_loading_finished() -> void:
	var _tween : Tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	_tween.tween_property(label, 'modulate:a', 0.0, fade_duration)
	_tween.tween_callback(_to_main_menu)


func _to_main_menu() -> void:
	SceneManager.to_scene(SceneManager.SCENE.MAIN_MENU)
