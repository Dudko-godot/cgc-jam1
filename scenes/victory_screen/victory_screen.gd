extends Control

#const MAIN_MENU = preload('res://scenes/main_menu/main_menu.tscn')
#const GAME = preload('res://scenes/levels/game.tscn')

@onready var enter_exit: AnimationPlayer = $EnterExit


func _go_to_main_menu() -> void:
	get_tree().change_scene_to_packed(SceneManager.main_menu)


func _go_again() -> void:
	get_tree().change_scene_to_packed(SceneManager.main_game)


func _on_button_main_menu_pressed() -> void:
	enter_exit.play('disappear')


func _on_button_again_pressed() -> void:
	enter_exit.play('disappear_to_game')
