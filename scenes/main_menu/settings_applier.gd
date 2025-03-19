extends Node

var is_fullscreen : bool = false

func _input(event_ : InputEvent) -> void:
	if event_.is_action_pressed('fullscreen_toggle'):
		_on_fullscreen_toggled()

func _on_fullscreen_toggled(is_true_ : bool = is_fullscreen) -> void:
	if is_true_:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		is_fullscreen = false
		return
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		is_fullscreen = true
		return
