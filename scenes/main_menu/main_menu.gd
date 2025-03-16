extends Control

@export_group('Internal Scene References')
@export_subgroup('Buttons')
@export var button_game_start : Button
@export var button_credits : Button
@export var button_exit : Button
@export_subgroup('Misc')
@export var darkener_animation_player : AnimationPlayer


signal start_game_clicked


func _ready() -> void:
	button_game_start.pressed.connect(_on_pressed_start)
	button_credits.pressed.connect(_on_pressed_credits)
	button_exit.pressed.connect(_on_pressed_exit)


func _on_pressed_start() -> void:
	#start_game_clicked.emit()
	darkener_animation_player.play('darken')


func _on_pressed_credits() -> void:
	pass


func _on_pressed_exit() -> void:
	get_tree().quit()


func start_game() -> void:
	pass
	#darkener_animation_player.play('darken')
