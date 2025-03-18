extends TextureRect

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func defeated() -> void:
	animation_player.play('defeated')
