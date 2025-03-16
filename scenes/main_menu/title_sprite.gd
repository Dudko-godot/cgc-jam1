extends AnimatedSprite2D


func _ready() -> void:
	play('intro')
	await animation_finished
	play('loop')
	
func _on_animation_finished() -> void:
	pass
	
func _on_game_start() -> void:
	play('outro')
