extends Node


@export var player : AnimationPlayer
@export var title : AnimatedSprite2D

@export_range(0.0, 10.0, 0.01) var delay : float = 1.0
@export_range(0.0, 2.0, 0.01) var speeed : float = 1.0

const ANIM_NAME : String = 'enter_father'


func _ready() -> void:
	await get_tree().create_timer(delay).timeout
	player.play(ANIM_NAME, -1, speeed)
