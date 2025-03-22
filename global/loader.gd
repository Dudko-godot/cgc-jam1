extends Node

## Threaded loader


signal loading_finished(request_ : LoadRequest)
signal reached_flag(name_ : String)

var thread : Thread = Thread.new()

## FIFO
var queue : Array[LoadRequest] = []
var current_load_request : LoadRequest = null

var current_request_start_time : int = 0
var is_output : bool = false


func _start_loading(request_ : LoadRequest) -> void:
	request_.get_started()
	current_load_request = request_
	
	current_request_start_time = Time.get_ticks_usec() # unimportant, just curious
	
	if request_ is LoadRequestResource:
		thread.start( request_._script.new )
	elif request_ is LoadRequestFile:
		thread.start( load.bind(request_.path) )



func _process(_delta : float) -> void:
	if thread.is_alive():
		return
	elif thread.is_started():
		_collect_thread()
		return
		
	_advance_queue()
	

func _advance_queue() -> void:
	if queue.is_empty() : return
	
	var _request : LoadRequest = queue.pop_front() as LoadRequest
	
	if _request is LoadRequestResource:
		if not _request.can_instantiate() :
			_request.get_failed()
			push_warning('ThreadedLoader | class ' + _request.name + ' cannot be instantiated')
			return
			
	elif _request is LoadRequestFile:
		if not _request.exists():
			_request.get_failed()
			push_warning('ThreadedLoader | ' + _request.path + ' does not exist')
			return

	# Everything else is considered a Flag
	else:
		printc('Reached a flag ' + _request.name)
		_request.get_fulfilled()
		reached_flag.emit(_request.name)
		return

	_start_loading(_request)


func _collect_thread() -> void:
	var _result : Variant = thread.wait_to_finish()
	
	if not (_result is Resource) : _result = null # Just in case
	
	current_load_request.get_fulfilled(_result)
	
	_report_collect_thread_results(_result)
	
	loading_finished.emit(current_load_request.get_fulfilled(_result))
	
	# Clear the current request. Maybe unnecessary?
	# Semantically it makes sense. It is "current", not "last" after all.
	if current_load_request : current_load_request = null


func _exit_tree():
	thread.wait_to_finish()


func queue_up(request_ : LoadRequest) -> void:
	queue.append(request_.get_queued())
	

func queue_up_multiple(requests_ : Array[LoadRequest]) -> void:
	for _request : LoadRequest in requests_:
		_request.get_queued()
	queue.append_array(requests_)


## Conditional print, ony if output is required
func printc(string_ : String) -> void:
	if not is_output : return
	print(string_)




## Console output, does not manipulate any data
# Hate seeing these giant strings in dicts, so Im shoving them inside this private method
func _report_collect_thread_results(result_ : Variant, request_ : LoadRequest = current_load_request) -> void:
	var _time_taken_seconds : float = 0.000001 * (Time.get_ticks_usec() - current_request_start_time)
	
	var _name : String = ''
	
	if request_ : _name = request_.name
	
	if result_ is Resource:
		if _name.is_empty() : _name = result_.resource_path
		printc('Loaded {path} successfully in {time} seconds'.format(
			{
				'path' : _name,
				'time' : str(_time_taken_seconds).pad_decimals(2)
			}
		))
	else:
		printc("Loaded something that wasn't a resource successfully in {time} seconds".format(
			{
				'time' : str(_time_taken_seconds).pad_decimals(2)
			}
		))
