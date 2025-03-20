extends Control

@export var game_title : String = ''
@export var fade_duration : float = 0.5
@export var label : RichTextLabel
@export var animation_player : AnimationPlayer

const MESSAGE : String = '[center][wave amp=50.0 freq=5.0 connected=0] {text}... [/wave][/center]'

func _ready() -> void:
	DisplayServer.window_set_title(tr('GAME_TITLE'))
	label.text = MESSAGE.format(
		{
			'text' : tr('LOADING')
		}
	)
	
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
