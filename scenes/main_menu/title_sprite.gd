extends AnimatedSprite2D

@export var main_menu : MainMenu

func _ready() -> void:
	play('intro')
	await animation_finished
	
	if not main_menu.is_start_requested : play('loop')
	
func _on_animation_finished() -> void:
	pass
	
func _on_game_start() -> void:
	play('outro')
