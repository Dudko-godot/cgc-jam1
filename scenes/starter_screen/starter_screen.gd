extends Control

@export var game_title : String = ''

@export var fade_duration : float = 0.5

@export var label : RichTextLabel
@export var animation_player : AnimationPlayer

 
func _ready() -> void:
	DisplayServer.window_set_title(game_title)
	
	if SceneManager.is_everything_loaded:
		_on_loading_finished()
		return
		
	SceneManager.full_loading_complete.connect(_on_loading_finished)


#func _process(_delta: float) -> void:
	#if SceneManager.is_everything_loaded : _on_loading_finished()


func _to_main_menu() -> void:
	SceneManager.to_scene(SceneManager.SCENE.MAIN_MENU)



func _on_loading_finished() -> void:
	animation_player.play('outro')
