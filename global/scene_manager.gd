extends Node

## Scenes to load
@export var paths : Array[LoadInfo]

const FLAG_NAME : String = 'SceneManager'

var scenes : Dictionary = {}
var instances : Dictionary = {}

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
	instances[name_] = []


func _prepare_victory_screen() -> void:
	Instantiator.queue_up(_get_scene_from_enum(SCENE.VICTORY_SCREEN))


func _get_name_from_enum(scene_enum_ : SCENE) -> String:
	var _name : String = ''
	
	match scene_enum_:
		SCENE.MAIN_MENU:
			_name = 'main_menu'
		SCENE.MAIN_GAME:
			_name = 'game'
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



func _on_instantiation_request_fulfilled(request_ : InstantiationRequest) -> void:
	instances[request_.scene.resource_path.get_file().get_slice('.', 0)].append(request_)



## Returns pre
func _change_scene_to_instantiated(new_scene_ : Node) -> void:
	var _tree : SceneTree = get_tree()
	var _current_scene : Node = _tree.current_scene
	
	_tree.root.add_child(new_scene_)
	_tree.root.remove_child(_current_scene)
	
	_tree.current_scene = new_scene_
	
	_current_scene.queue_free()


func to_scene(scene_enum_ : SCENE) -> void:
	var _scene : PackedScene = _get_scene_from_enum(scene_enum_)
	if not _scene : return
	get_tree().change_scene_to_packed(_scene)


func request_instance(scene_enum_ : SCENE) -> void:
	var _scene : PackedScene = _get_scene_from_enum(scene_enum_)
	if not _scene : return
	Instantiator.queue_up(_scene).fulfilled.connect(_on_instantiation_request_fulfilled)


func to_instantiated(scene_enum_ : SCENE) -> void:
	var _scene : PackedScene = _get_scene_from_enum(scene_enum_)
	
	if not _scene : return
	
	var _name : String = _get_name_from_enum(scene_enum_)
	
	## actually Array[InstantiationRequest] but arrays are untyped :()
	var _request_array : Array = instances[_name]
	
	if _request_array.is_empty():
		# Use default method
		get_tree().change_scene_to_packed(_scene)
	else:
		# Go looking for an unclaimed request
		
		for _index : int in range(_request_array.size()):
			var _request : InstantiationRequest = _request_array[_index] as InstantiationRequest
			if _request.status != InstantiationRequest.STATUS.FULFILLED: continue
			_change_scene_to_instantiated(_request.claim())
			_request_array.pop_at(_index)
			return
		# Default method if everything has been claimed already
		get_tree().change_scene_to_packed(_scene)
		
	print('No unclaimed buffered instances of ' + _name + ', using change_scene_to_packed() instead')
