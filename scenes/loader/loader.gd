class_name LoaderThreaded extends Node

## Threaded loader

signal loading_finished
## Same as loading_finished, but with data attached
signal loading_finished_payload(asset_ : Resource, name_ : String)
signal reached_flag(name_ : String)

var thread : Thread = Thread.new()

## FIFO, items at the end get loaded first
var queue : Array[LoadInfo] = []
var current_load_info : LoadInfo = null


func _start_loading(path_ : String) -> void:
	thread.start( load.bind(path_) )


## Thread funciton
func _load(path_ : String) -> Resource:
	return load(path_)


func _process(_delta : float) -> void:
	if thread.is_alive():
		#print('Alive')
		return
	elif thread.is_started():
		_collect_thread()
		return
		
	_advance_queue()
	

func _advance_queue() -> void:
	if queue.is_empty() : return
	
	var _info : LoadInfo = queue.pop_back() as LoadInfo
	
	if _info is LoadInfoFile:
		if not _info.exists():
			print(_info.path + ' does not exist')
			return
	## Everything else is considered a Flag
	else: # if _info is LoadInfoFlag:
		print('Reached a flag ' + _info.name)
		reached_flag.emit(_info.name)
		return

	current_load_info = _info
	_start_loading(_info.path)


func _collect_thread() -> void:
	var _result : Variant = thread.wait_to_finish()
	
	var _name : String = ''
	if current_load_info :
		_name = current_load_info.name
		current_load_info = null
	
	loading_finished.emit()
	
	if _result is Resource:
		print('Loaded ' + _result.resource_path  + ' successfully')
		loading_finished_payload.emit(_result, _name)
	else:
		print("Loaded something that wasn't a resource")
		loading_finished_payload.emit(null, _name)
	

func _exit_tree():
	thread.wait_to_finish()


func queue_up(path_ : LoadInfo) -> void:
	queue.append(path_)
	

func queue_up_multiple(paths_ : Array[LoadInfo]) -> void:
	queue.append_array(paths_)
