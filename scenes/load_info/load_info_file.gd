class_name LoadInfoFile extends LoadInfo

## Information about a file's location
## And the name to store it

@export var path : String = ''
@export var use_resource_name : bool = true

func get_started() -> void:
	if use_resource_name:
		name = _get_file_name()


func exists() -> bool:
	if not path.is_absolute_path : return false
	if not ResourceLoader.exists(path) : return false
	return true


func _get_file_name() -> String:
	return _get_file_full_name().get_slice('.', 0)
	

func _get_file_full_name() -> String:
	if not path.is_absolute_path : return ''
	return path.get_file()
