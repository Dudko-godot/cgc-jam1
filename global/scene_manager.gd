extends Node

## Scenes to load
@export var paths : Array[LoadInfo]
@export var loader : LoaderThreaded

const FLAG_NAME : String = 'SceneManager'

var scenes : Dictionary = {}
var is_everything_loaded = false

signal full_loading_complete
signal loaded_scene(parameter_name_ : String)

enum SCENE {
	MAIN_MENU,
	MAIN_GAME,
	VICTORY_SCREEN,
	DEFEAT_SCREEN
}


func _ready() -> void:
	loader.queue_up_multiple(paths)
	
	loader.loading_finished_payload.connect(_on_loaded)
	loader.reached_flag.connect(_on_flag_reached)
	
	full_loading_complete.emit()
	
	
func _on_flag_reached(name_ : String) -> void:
	if not name_ == FLAG_NAME : return

	loader.reached_flag.disconnect(_on_flag_reached)
	is_everything_loaded = true
	full_loading_complete.emit()


func _on_loaded(resource_ : Resource, name_ : String) -> void:
	if name_.is_empty():
		print(name_)
		return
		
	scenes[name_] = resource_

func to_scene(scene_ : SCENE) -> void:
	var _name : String = _name_from_enum(scene_)
	
	if not scenes.keys().has(_name):
		print(_name + ' is not loaded by SceneManager as of yet')
		return
	
	if not scenes[_name]:
		print(_name + ' is null')
		return
		
	get_tree().change_scene_to_packed(scenes[_name] as PackedScene)


func _name_from_enum(scene_ : SCENE) -> String:
	var _name : String = ''
	
	match scene_:
		SCENE.MAIN_MENU:
			_name = 'main_menu'
		SCENE.MAIN_GAME:
			_name = 'main_game'
		SCENE.DEFEAT_SCREEN:
			_name = 'defeat_screen'
		SCENE.VICTORY_SCREEN:
			_name = 'victory_screen'
			
	return _name


	


'res://scenes/levels/game.tscn'
'res://scenes/defeat_screen/defeat_screen.tscn'
'res://scenes/victory_screen/victory_screen.tscn'
'res://scenes/main_menu/main_menu.tscn'
