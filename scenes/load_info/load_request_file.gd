class_name LoadRequestFile extends LoadRequest

## Information about a file's location
## And the name to store it

@export var path : String = ''
@export var automatic_name : bool = true


func _init(path_ : String = '') -> void:
	if path_.is_empty() : return
	path = path_


func exists() -> bool:
	if not path.is_absolute_path : return false
	if not ResourceLoader.exists(path) : return false
	return true
	

func _get_file_name() -> String:
	return _get_file_full_name().get_slice('.', 0)


func _get_file_full_name() -> String:
	if not path.is_absolute_path : return ''
	return path.get_file()


func get_queued() -> LoadRequest:
	if automatic_name : name = _get_file_full_name()
	return super()
