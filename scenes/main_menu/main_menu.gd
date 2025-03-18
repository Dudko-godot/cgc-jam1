class_name MainMenu extends Control

@export_group('Internal Scene References')
@export_subgroup('Buttons')
@export var button_game_start : Button
@export var button_credits : Button
@export var button_exit : Button
@export_subgroup('Misc')
@export var darkener_animation_player : AnimationPlayer
@export var loader : BackgroundLoader

#signal start_game_clicked
var is_start_requested : bool = false


func _ready() -> void:
	is_start_requested = false
	
	button_game_start.pressed.connect(_on_pressed_start)
	button_credits.pressed.connect(_on_pressed_credits)
	button_exit.pressed.connect(_on_pressed_exit)


func _on_pressed_start() -> void:
	is_start_requested = true
	darkener_animation_player.play('darken')


func _on_pressed_credits() -> void:
	pass


func _on_pressed_exit() -> void:
	get_tree().quit()

## Assumes it is loaded
func start_game() -> void:
	get_tree().change_scene_to_packed(SceneManager.main_game) 
	#darkener_animation_player.play('darken')
