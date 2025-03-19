extends Node

## Threaded Instantiantor

signal instantiation_finished
## Same as instantiation_finished, but with data attached
signal instantiation_finished_payload(node_ : Node)

var thread : Thread = Thread.new()

## FIFO
var queue : Array[PackedScene] = []
var currently_instantiating_scene : PackedScene = null


func _start_instantiating(scene_ : PackedScene) -> void:
	thread.start(scene_.instantiate)


func _process(_delta : float) -> void:
	if thread.is_alive():
		return
	elif thread.is_started():
		_collect_thread()
		return
		#
	_advance_queue()
	

func _advance_queue() -> void:
	if queue.is_empty() : return
	
	var _scene : PackedScene = queue.pop_front() as PackedScene
	
	if not _scene.can_instantiate() : return

	currently_instantiating_scene = _scene
	
	_start_instantiating(_scene)


func _collect_thread() -> void:
	var _result : Node = thread.wait_to_finish()

	if currently_instantiating_scene :
		currently_instantiating_scene = null
	
	instantiation_finished.emit()
	
	if _result is Node:
		print('Instantiated ' + _result.name  + ' successfully')
		instantiation_finished_payload.emit(_result)
	else:
		print("Failed to instantiate a scene")
		instantiation_finished_payload.emit(null)
	

func _exit_tree():
	thread.wait_to_finish()


func queue_up(scene_ : PackedScene) -> void:
	queue.append(scene_)
	

func queue_up_multiple(scenes_ : Array[PackedScene]) -> void:
	queue.append_array(scenes_)
