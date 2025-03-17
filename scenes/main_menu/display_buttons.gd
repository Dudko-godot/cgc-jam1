extends AnimationPlayer


@export var loader : BackgroundLoader

func _ready() -> void:
	if loader.is_loading_finished:
		_show_buttons()
		return
		
	loader.loading_finished.connect(_show_buttons, CONNECT_ONE_SHOT)


func _show_buttons() -> void:
	self.play('show_buttons')
