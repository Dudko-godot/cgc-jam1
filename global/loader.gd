extends Node

## Threaded loader

signal loading_finished
## Same as loading_finished, but with data attached
signal loading_finished_payload(asset_ : Resource, name_ : String)
signal reached_flag(name_ : String)

var thread : Thread = Thread.new()

## FIFO
var queue : Array[LoadInfo] = []
var current_load_info : LoadInfo = null

var current_request_start_time : int = 0
var is_output : bool = false

func _start_loading(info_ : LoadInfoFile) -> void:
	info_.get_started()
	current_load_info = info_
	
	current_request_start_time = Time.get_ticks_usec() # unimportant, just curious
	
	thread.start( load.bind(info_.path) )


func _process(_delta : float) -> void:
	if thread.is_alive():
		return
	elif thread.is_started():
		_collect_thread()
		return
		
	_advance_queue()
	

func _advance_queue() -> void:
	if queue.is_empty() : return
	
	var _info : LoadInfo = queue.pop_front() as LoadInfo
	
	if _info is LoadInfoFile:
		if not _info.exists():
			push_warning('ThreadedLoader | ' + _info.path + ' does not exist')
			return
			
	## Everything else is considered a Flag
	else: # if _info is LoadInfoFlag:
		printc('Reached a flag ' + _info.name)
		reached_flag.emit(_info.name)
		return

	_start_loading(_info)


func _collect_thread() -> void:
	var _result : Variant = thread.wait_to_finish()
	
	var _name : String = ''
	if current_load_info :
		_name = current_load_info.name
		current_load_info = null
	
	loading_finished.emit()
	
	if _result is Resource:
		printc('Loaded {name} successfully in {time} seconds'.format(
			{
				'name' : _result.resource_path,
				'time' : str((Time.get_ticks_usec() - current_request_start_time) * 0.000001).pad_decimals(2)
			}
		))
		loading_finished_payload.emit(_result, _name)
	else:
		printc("Loaded something that wasn't a resource")
		loading_finished_payload.emit(null, _name)
	

func _exit_tree():
	thread.wait_to_finish()


func queue_up(path_ : LoadInfo) -> void:
	queue.append(path_)
	

func queue_up_multiple(paths_ : Array[LoadInfo]) -> void:
	queue.append_array(paths_)


# princ_c(onditional), if output is required
func printc(string_ : String) -> void:
	if not is_output : return
	print(string_)
