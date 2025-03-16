extends Control

@export_group('Internal Scene References')
@export_subgroup('Buttons')
@export var button_game_start : Button
@export var button_credits : Button
@export var button_exit : Button


func _ready() -> void:
	button_game_start.pressed.connect(_on_pressed_start)
	button_credits.pressed.connect(_on_pressed_credits)
	button_exit.pressed.connect(_on_pressed_exit)


func _on_pressed_start() -> void:
	pass


func _on_pressed_credits() -> void:
	pass


func _on_pressed_exit() -> void:
	get_tree().quit()
