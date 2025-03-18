class_name LoadersManager extends Node

@export var victory_screen_loader : BackgroundLoader
@export var defeat_screen_loader : BackgroundLoader
@export var main_game_loader : BackgroundLoader

signal loaded_everything

const LOADED_TOTAL : int = 3
var loaded_current : int = 0 : set = _set_loaded_current


func _ready() -> void:
	if SceneManager.is_everything_loaded : return
	
	_load_all()

func _set_loaded_current(value_ : int) -> void:
	#if loaded_current == value_ : return
	loaded_current = value_
	if loaded_current == LOADED_TOTAL :
		loaded_everything.emit()
		print('Loaded Everything!')


func _load_all() -> void:
	victory_screen_loader.loading_finished.connect(
		func() -> void:
			#SceneManager.victory_screen = victory_screen_loader.target_resource
			#victory_screen_loader.queue_free()
			loaded_current += 1,
		CONNECT_ONE_SHOT
	)

	defeat_screen_loader.loading_finished.connect(
		func() -> void:
			#SceneManager.defeat_screen = defeat_screen_loader.target_resource
			#defeat_screen_loader.queue_free()
			loaded_current += 1,
		CONNECT_ONE_SHOT
	)

	main_game_loader.loading_finished.connect(
		func() -> void:
			#SceneManager.main_menu = main_game_loader.target_resource
			#main_game_loader.queue_free()
			loaded_current += 1,
		CONNECT_ONE_SHOT
	)
