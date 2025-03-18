class_name LoadInfoFile extends LoadInfo

## Information about a file's location
## And the name to store it

@export var path : String = ''


func exists() -> bool:
	if not path.is_absolute_path : return false
	if not ResourceLoader.exists(path) : return false
	return true
