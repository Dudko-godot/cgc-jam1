class_name BackgroundLoader extends Node

#@export var target_resource : PackedScene

var target_resource = PackedScene

# Путь к сцене для фоновой загрузки
@export var path : String = '' # Do not touch

var is_loading : bool = false
var is_loading_finished : bool = false

signal loading_finished


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_start_loading()


func _process(_delta : float) -> void:
	if not is_loading :
		return
	
	var _status : ResourceLoader.ThreadLoadStatus = ResourceLoader.load_threaded_get_status(path)
	
	match _status:
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			_on_loading_finished()
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_FAILED:
			print('Failed to load ' + path)
		

func _start_loading() -> void:
	is_loading = true
	ResourceLoader.load_threaded_request(path)


func _on_loading_finished() -> void:
	target_resource = ResourceLoader.load_threaded_get(path)
	is_loading = false
	is_loading_finished = true
	print('Loaded ' + path + ' successfully.')
	loading_finished.emit()
