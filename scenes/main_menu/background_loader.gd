class_name BackgroundLoader extends Node

#@export var target_resource : PackedScene

var target_resource = PackedScene

# Путь к сцене для фоновой загрузки
@export var path : String = '' # Do not touch
@export var autoload : bool = false

var is_loading : bool = false
var is_loading_finished : bool = false


signal loading_finished


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not autoload : return
	start_loading()


func _process(_delta : float) -> void:
	if not is_loading :
		return
	
	var _status : ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(path)
	
	var _status_description : String = 'OK'
	
	match _status:
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_INVALID_RESOURCE:
			_status_description = 'Invalid'
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
			_status_description = 'In Progress'
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
			_status_description = 'Failed'
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			_status_description = 'Loaded'
			
	if _status != ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
		print('{status} || {path}'.format(
			{
				'status' : _status_description,
				'path' : path
			}
		))
	
	match _status:
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			_on_loading_finished()
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
			print('Failed to load ' + path)
		

func start_loading(path_ : String = path) -> Signal:
	is_loading = true
	var _error : Error = ResourceLoader.load_threaded_request(path_)
	var _message : String = ''
	
	match _error:
		0:
			_message = 'Started loading {path}'
		_:
			_message = 'Failed to start loading {path}'
	
	print(_message.format(
			{
				'path' : path_
			}
		)
	)
	
	return loading_finished


func _on_loading_finished() -> void:
	target_resource = ResourceLoader.load_threaded_get(path)
	is_loading = false
	is_loading_finished = true
	print('Loaded ' + path + ' successfully.')
	loading_finished.emit()
