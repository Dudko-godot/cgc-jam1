class_name EyeChild extends Node2D

@onready var blinking: AnimationPlayer = $Blinking

func blink() -> void:
	blinking.play('blink')
