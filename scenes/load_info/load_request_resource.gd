class_name LoadRequestResource extends LoadRequestFile

## Creating an instance of a resource instead of loading a file
## Expects a path to a valid resource, ouf course

var _script : Script = null


func get_queued() -> LoadRequest:
	_script = load(path)
	return super()


func can_instantiate() -> bool:
	return _script.can_instantiate()
