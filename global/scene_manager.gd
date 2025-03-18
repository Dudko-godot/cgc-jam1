extends Node

var main_menu : PackedScene = preload('res://scenes/main_menu/main_menu.tscn')
var main_game : PackedScene = preload('res://scenes/levels/game.tscn')
var victory_screen : PackedScene = preload('res://scenes/victory_screen/victory_screen.tscn')
var defeat_screen : PackedScene = preload('res://scenes/defeat_screen/defeat_screen.tscn')

@export var loader_main_menu : BackgroundLoader
@export var loader_main_game : BackgroundLoader
@export var loader_victory_screen : BackgroundLoader
@export var loader_defeat_screen : BackgroundLoader

## Managed by it, not in general
const SCENES_TOTAL : int = 4
var scenes_loaded : int = 4 : set = _set_scenes_loaded


func _set_scenes_loaded(value_ : int) -> void:
	if scenes_loaded == value_ : return
	
	scenes_loaded = value_
	if scenes_loaded == SCENES_TOTAL : full_loading_complete.emit()


signal full_loading_complete
signal loaded_scene(parameter_name_ : String)


func is_everything_loaded() -> bool:
	if not main_menu : return false
	if not main_game : return false
	if not victory_screen : return false
	if not defeat_screen : return false
	return true
	

func _ready() -> void:
	full_loading_complete.emit()
	return
	
	loader_main_menu.loading_finished.connect(
		_on_loading_finished.bind(loader_main_menu, 'main_menu'), CONNECT_ONE_SHOT)
		
	loader_main_game.loading_finished.connect(
		_on_loading_finished.bind(loader_main_game, 'main_game'), CONNECT_ONE_SHOT)
		
	loader_victory_screen.loading_finished.connect(
		_on_loading_finished.bind(loader_victory_screen, 'victory_screen'), CONNECT_ONE_SHOT)
		
	loader_defeat_screen.loading_finished.connect(
		_on_loading_finished.bind(loader_defeat_screen, 'defeat_screen'), CONNECT_ONE_SHOT)


func _on_loading_finished(loader_ : BackgroundLoader, parameter_name_ : String) -> void:
	self.set(parameter_name_, loader_.target_resource as PackedScene)
	scenes_loaded += 1
	loaded_scene.emit(parameter_name_)
