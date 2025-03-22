class_name LoadRequest extends Resource

## Baseline class serves as a flag

@export var name : String = ''

var status : STATUS = STATUS.STRANDED

enum STATUS {
	STRANDED,			# The default, when still outside of the queue
	QUEUED,				
	FAILED_TO_START,	
	PROCESSING,
	FULFILLED
}

signal fulfilled
signal failed

var result : Resource


func _init(name_ : String = '') -> void:
	if name_.is_empty() : return
	name = name_


func get_queued() -> LoadRequest:
	status = STATUS.QUEUED
	return self


func get_started() -> LoadRequest:
	status = STATUS.PROCESSING
	return self


func get_failed() -> LoadRequest:
	status = STATUS.FAILED_TO_START
	failed.emit()
	return self


func get_fulfilled(result_ : Resource = null) -> LoadRequest:
	result = result_
	status = STATUS.FULFILLED
	fulfilled.emit()
	return self
