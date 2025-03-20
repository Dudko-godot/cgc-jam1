class_name MainMenu extends Control

@export_group('External References')
@export_subgroup('Rulesets')
@export var default_ruleset : GameRuleset
@export var relaxed_ruleset : GameRuleset

@export_group('Internal Scene References')
@export_subgroup('Buttons')
@export var button_game_start : Button
@export var button_game_start_relaxed : Button
@export var button_settings : Button
@export var button_credits : Button
@export var button_exit : Button
@export_subgroup('Menus')
@export var main_buttons : Control
@export var settings_ui : SetttingsUI
@export_subgroup('Misc')
@export var darkener_animation_player : AnimationPlayer

#signal start_game_clicked
var is_start_requested : bool = false

func _ready() -> void:
	CurrentRuleset.ruleset = default_ruleset
	
	is_start_requested = false
	
	settings_ui.settings_closed.connect(_show_main_buttons)
	
	button_game_start.pressed.connect(_on_pressed_start.bind(default_ruleset))
	button_game_start_relaxed.pressed.connect(_on_pressed_start.bind(relaxed_ruleset))
	
	button_settings.pressed.connect(_on_settings_pressed)
	button_credits.pressed.connect(_on_pressed_credits)
	button_exit.pressed.connect(_on_pressed_exit)
	
	SceneManager.request_instance(SceneManager.SCENE.MAIN_GAME)


func _on_pressed_start(ruleset_ : GameRuleset = default_ruleset) -> void:
	CurrentRuleset.ruleset = ruleset_
	is_start_requested = true
	darkener_animation_player.play('darken')


func _on_pressed_credits() -> void:
	pass


func _on_pressed_exit() -> void:
	get_tree().quit()

## Assumes it is loaded
func start_game() -> void:
	SceneManager.to_instantiated(SceneManager.SCENE.MAIN_GAME)


func _show_main_buttons() -> void:
	main_buttons.modulate.a = 1.0


func _on_settings_pressed() -> void:
	main_buttons.modulate.a = 0.0
	settings_ui.enter()
