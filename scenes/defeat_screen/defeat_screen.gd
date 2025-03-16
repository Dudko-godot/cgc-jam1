extends Control


@export var lose_prompt : AnimatedSprite2D


func _process(delta: float) -> void:
	if Input.is_action_just_pressed('ui_accept'):
		$AnimationPlayer.play('default')
	
