extends Node

## Scenes to load
@export var paths : Array[LoadInfo]

const FLAG_NAME : String = 'SceneManager'

var scenes : Dictionary = {}
var is_everything_loaded = false

signal full_loading_complete

enum SCENE {
	MAIN_MENU,
	MAIN_GAME,
	VICTORY_SCREEN,
	DEFEAT_SCREEN
}


func _ready() -> void:
	Loader.queue_up_multiple(paths)
	
	Loader.loading_finished_payload.connect(_on_loaded)
	Loader.reached_flag.connect(_on_flag_reached)
	
	full_loading_complete.emit()
	
	
func _on_flag_reached(name_ : String) -> void:
	if not name_ == FLAG_NAME : return

	Loader.reached_flag.disconnect(_on_flag_reached)
	is_everything_loaded = true
	full_loading_complete.emit()


func _on_loaded(resource_ : Resource, name_ : String) -> void:
	if name_.is_empty():
		print(name_)
		return
		
	scenes[name_] = resource_


func to_scene(scene_enum_ : SCENE) -> void:
	var _scene : PackedScene = _get_scene_from_enum(scene_enum_)
	if not _scene : return
	get_tree().change_scene_to_packed(_scene)


## Returns pre
func to_instantiated(scene_ : Node) -> void:
	var _tree : SceneTree = get_tree()
	var _current_scene : Node = _tree.current_scene
	_tree.root.add_child(scene_)
	
	_tree.root.remove_child(_current_scene)
	_current_scene.queue_free()


func instantiate(scene_enum_ : SCENE) -> void:
	var _scene : PackedScene = _get_scene_from_enum(scene_enum_)
	if not _scene : return
	Instantiator.queue_up(_scene)




func _get_name_from_enum(scene_enum_ : SCENE) -> String:
	var _name : String = ''
	
	match scene_enum_:
		SCENE.MAIN_MENU:
			_name = 'main_menu'
		SCENE.MAIN_GAME:
			_name = 'main_game'
		SCENE.DEFEAT_SCREEN:
			_name = 'defeat_screen'
		SCENE.VICTORY_SCREEN:
			_name = 'victory_screen'
			
	return _name


func _get_scene_from_enum(scene_enum_ : SCENE) -> PackedScene:
	var _name : String = _get_name_from_enum(scene_enum_)
	
	if not scenes.keys().has(_name):
		print(_name + ' is not loaded by SceneManager as of yet')
		return null
	
	if not scenes[_name]:
		print(_name + ' is null')
		return null
		
	return scenes[_name]

'res://scenes/levels/game.tscn'
'res://scenes/defeat_screen/defeat_screen.tscn'
'res://scenes/victory_screen/victory_screen.tscn'
'res://scenes/main_menu/main_menu.tscn'
