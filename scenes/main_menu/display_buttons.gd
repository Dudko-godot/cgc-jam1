extends AnimationPlayer


@export var loaders_manager : LoadersManager

func _ready() -> void:
	if SceneManager.is_everything_loaded():
		_show_buttons()
		return

	SceneManager.full_loading_complete.connect(_show_buttons, CONNECT_ONE_SHOT)


func _show_buttons() -> void:
	self.play('show_buttons')
