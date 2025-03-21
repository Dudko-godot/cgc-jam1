extends Node2D

@export var animation_player : AnimationPlayer

func _ready() -> void:
	hide()
	
func play() -> void:
	animation_player.play('default')
