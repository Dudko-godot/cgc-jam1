extends Control


@export var lose_prompt : AnimatedSprite2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed('ui_accept'):
		$AnimationPlayer.play('default')
	

const MAIN_MENU = preload('res://scenes/main_menu/main_menu.tscn')
const GAME = preload('res://scenes/levels/game.tscn')

@onready var exit_player : AnimationPlayer = $ExitPlayer


func _go_to_main_menu() -> void:
	get_tree().change_scene_to_packed(MAIN_MENU)


func _go_again() -> void:
	get_tree().change_scene_to_packed(GAME)


func _on_button_main_menu_pressed() -> void:
	exit_player.play('disappear')


func _on_button_again_pressed() -> void:
	exit_player.play('disappear_to_game')
