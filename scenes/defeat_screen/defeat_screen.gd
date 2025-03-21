extends Control

const GAME = preload('res://scenes/levels/game.tscn')

@export var lose_prompt : AnimatedSprite2D
@onready var exit_player : AnimationPlayer = $ExitPlayer


func _go_to_main_menu() -> void:
	get_tree().change_scene_to_packed(SceneManager.main_menu)


func _go_again() -> void:
	get_tree().change_scene_to_packed(SceneManager.main_game)


func _on_button_main_menu_pressed() -> void:
	exit_player.play('disappear')


func _on_button_again_pressed() -> void:
	exit_player.play('disappear_to_game')
