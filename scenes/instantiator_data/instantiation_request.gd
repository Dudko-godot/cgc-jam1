class_name InstantiationRequest extends Resource

## Used by Instantiator singleton
## Helps to keep track between different functions requesting
## different [Node]s of the same [PackedScene]

enum STATUS {
	UNDEFINED,
	QUEUED, 				# The request is still in queue
	FAILED_TO_START,		# Probably because scene.can_instantiate() returned false
	PROCESSING,				# [PackedScene] is being instantiated right now
	FAILED_TO_INSTANTIATE,	# Self-explanatory, should never happen
	FULFILLED,				# Finished
	CLAIMED					# Some function is planning to use the prepared node
}

signal fulfilled(request_ : InstantiationRequest)
signal failed

var status : STATUS = STATUS.UNDEFINED

var scene : PackedScene
var node : Node


func _init(scene_ : PackedScene = null) -> void:
	if not scene_ : return
	else: get_enqueued(scene_)


func get_enqueued(scene_ : PackedScene) -> void:
	scene = scene_
	status = STATUS.QUEUED


func get_started() -> void:
	status = STATUS.PROCESSING
	

func get_finished(node_ : Node) -> void:
	node = node_
	status = STATUS.FULFILLED
	fulfilled.emit(self)


func claim() -> InstantiationRequest:
	status = STATUS.CLAIMED
	#free.call_deferred()
	return self


func get_failed_to_start() -> void:
	status = STATUS.FAILED_TO_START
	failed.emit()
	free.call_deferred()

	push_warning('Failed to start threaded instantiating of ' + scene.resource_path.get_file())


func get_failed() -> void:
	status = STATUS.FAILED_TO_INSTANTIATE
	failed.emit()
	free.call_deferred()
	
	push_warning('Failed to instantiate on a thread ' + scene.resource_path.get_file())
