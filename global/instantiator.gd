extends Node

## Threaded Instantiantor
var thread : Thread = Thread.new()

## FIFO
var queue : Array[InstantiationRequest] = []
var current_request : InstantiationRequest = null

# Misc
var current_request_start_time : int = 0
var is_output : bool = false


## Assumes that the scene inside of [InstantiationRequest] can be instantiated
func _start_procesing_request(request_ : InstantiationRequest) -> void:
	if not request_.scene.can_instantiate() :
		request_.get_failed_to_start()
		return
	
	current_request_start_time = Time.get_ticks_usec() # unimportant, just curious
	
	current_request = request_
	request_.get_started()
	thread.start(request_.scene.instantiate)


func _process(_delta : float) -> void:
	if thread.is_alive():
		return
	elif thread.is_started():
		_collect_thread()
		return
		
	_advance_queue()
	

func _advance_queue() -> void:
	if queue.is_empty() : return
	
	var _request : InstantiationRequest = queue.pop_front() as InstantiationRequest
	
	_start_procesing_request(_request)


func _collect_thread() -> void:
	var _result : Node = thread.wait_to_finish()
	#instantiation_finished.emit()
	
	var _time_taken : int = Time.get_ticks_usec() - current_request_start_time 
	
	if not current_request : return
	
	if _result is Node:
		# This causes [InstantiationRequest] to emit a signal
		# for its presumed author to collect
		current_request.get_finished(_result)
		
		# If no one was there to collect the signal, the following line
		# shall delete the only record of this request from memory, rendering
		# the efforts of instantiating it void.
		current_request = null
		
		_printc('Instantiated {name} successfully in {time} usec'.format(
			{
				'name' : _result.name,
				'time' : _time_taken
			}
		))
	else:
		push_warning('Failed to instantiate a scene')



func _exit_tree():
	thread.wait_to_finish()


func queue_up(scene_ : PackedScene) -> InstantiationRequest:
	var _request : InstantiationRequest = InstantiationRequest.new(scene_)
	queue.append(_request)
	return _request
	

func queue_up_multiple(scenes_ : Array[PackedScene]) -> Array[InstantiationRequest]:
	var _requests : Array[InstantiationRequest] = []
	
	for _index : int in range(scenes_.size()):
		_requests[_index] = InstantiationRequest.new(scenes_[_index])
	
	queue.append_array(_requests)
	return _requests



# princ_c(onditional), if output is required
func _printc(string_ : String) -> void:
	if not is_output : return
	print(string_)
