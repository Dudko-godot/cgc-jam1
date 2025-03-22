extends Node


const PATH_MAIN_GAME : String = 'res://scenes/levels/game.tscn'
const PATH_MAIN_MENU : String = 'res://scenes/main_menu/main_menu.tscn'
const PATH_DEFEAT_SCREEN : String = 'res://scenes/defeat_screen/defeat_screen.tscn'
const PATH_VICTORY_SCREEN : String = 'res://scenes/victory_screen/victory_screen.tscn'

## Scenes to load
#var requests : Array[LoadRequest]

const FLAG_NAME : String = 'SceneManager'

var scenes : Dictionary = {}
var instances : Dictionary = {}

## Requesting another instance via [method request_instance] would be denied
## if there is this at least this amount of unclaimed instances ready to go.
const MAX_SAME_INSTANCE_AMOUNT : int = 5

var is_everything_loaded = false

signal full_loading_complete

enum SCENE {
	MAIN_MENU,
	MAIN_GAME,
	VICTORY_SCREEN,
	DEFEAT_SCREEN
}


func _ready() -> void:
	Loader.queue_up_multiple(
		[
				LoadRequestFile.new(PATH_MAIN_MENU),
				LoadRequestFile.new(PATH_MAIN_GAME),
				LoadRequestFile.new(PATH_VICTORY_SCREEN),
				LoadRequestFile.new(PATH_DEFEAT_SCREEN),
				LoadRequest.new(FLAG_NAME)
			]
		)
	
	Loader.loading_finished.connect(_on_loaded)
	Loader.reached_flag.connect(_on_flag_reached)
	
	full_loading_complete.emit()


	
func _on_flag_reached(name_ : String) -> void:
	if not name_ == FLAG_NAME : return

	Loader.reached_flag.disconnect(_on_flag_reached)
	is_everything_loaded = true
	full_loading_complete.emit()


func _on_loaded(request_ : LoadRequestFile) -> void:
	if request_.name.is_empty():
		return
		
	scenes[request_.name] = request_.result
	instances[request_.name] = []


func _prepare_victory_screen() -> void:
	Instantiator.queue_up(_get_scene_from_enum(SCENE.VICTORY_SCREEN))


func _get_name_from_enum(scene_enum_ : SCENE) -> String:
	var _name : String = ''
	
	match scene_enum_:
		SCENE.MAIN_MENU:
			_name = PATH_MAIN_MENU.get_file()
		SCENE.MAIN_GAME:
			_name = PATH_MAIN_GAME.get_file()
		SCENE.DEFEAT_SCREEN:
			_name = PATH_DEFEAT_SCREEN.get_file()
		SCENE.VICTORY_SCREEN:
			_name = PATH_VICTORY_SCREEN.get_file()
			
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
	instances[request_.scene.resource_path.get_file()].append(request_)



## Returns pre
func _change_scene_to_instantiated(new_scene_ : Node) -> void:
	var _tree : SceneTree = get_tree()
	var _current_scene : Node = _tree.current_scene
	
	if not new_scene_.is_inside_tree():
		_tree.root.add_child(new_scene_)
	_tree.root.remove_child(_current_scene)
	
	_tree.current_scene = new_scene_
	
	_current_scene.queue_free()


func to_scene(scene_enum_ : SCENE) -> void:
	var _scene : PackedScene = _get_scene_from_enum(scene_enum_)
	if not _scene : return
	get_tree().change_scene_to_packed(_scene)


func request_instance(scene_enum_ : SCENE) -> void:
	var _name : String = _get_name_from_enum(scene_enum_)

	if not instances.keys().has(_name):
		push_warning('Instances of "' + _name  + '" are not kept track of by SceneManager')
		return

	var _existing_instances = instances[_name]

	if _existing_instances.size() >= MAX_SAME_INSTANCE_AMOUNT :
		push_warning('Request for a threaded instantiating of {name} denied : too many unclaimed instances'.format(
			{
				'name' : _get_name_from_enum(scene_enum_)
			}
		))
		return
		
	var _scene : PackedScene = _get_scene_from_enum(scene_enum_)
	if not _scene : return
	
	Instantiator.queue_up(_scene).fulfilled.connect(_on_instantiation_request_fulfilled)


func to_instantiated(scene_enum_ : SCENE) -> void:
	var _request : InstantiationRequest = _get_unclaimed_request(scene_enum_)
	
	if _request :
		_change_scene_to_instantiated(_request.claim().node)
		return
	
	var _scene : PackedScene = _get_scene_from_enum(scene_enum_)
	if not _scene : return
	
	get_tree().change_scene_to_packed(_scene)
	print('No unclaimed buffered instances of ' + _get_name_from_enum(scene_enum_) + ', using change_scene_to_packed() instead')
	

## Successfully running this claims the request
func _get_unclaimed_request(scene_enum_ : SCENE) -> InstantiationRequest:
	var _name : String = _get_name_from_enum(scene_enum_)
	
	if not instances.keys().has(_name) : return null
	
	var _request_array : Array = instances[_name]
	if _request_array.is_empty(): return null
	
	# Go looking for an unclaimed request
	for _index : int in range(_request_array.size()):
		var _request : InstantiationRequest = _request_array[_index] as InstantiationRequest
		if _request.status != InstantiationRequest.STATUS.FULFILLED: continue
		_request_array.pop_at(_index)
		return _request.claim()
	return null

# DEPRECATED
## Ruleset will only be applied if the instanced request goes through correctly
func to_main_game(ruleset_ : GameRuleset) -> void:
	var _request : InstantiationRequest = _get_unclaimed_request(SCENE.MAIN_GAME)
	
	if not _request :
		to_scene(SCENE.MAIN_MENU)
		return
	
	var _main_game : MainGame = _request.node as MainGame
	_main_game.ruleset = ruleset_
	_change_scene_to_instantiated(_request.node)
