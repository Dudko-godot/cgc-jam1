extends Node


@export var sprite : CoolSprite2D
@export var eye : FatherEye


func _ready() -> void:
	if not(sprite and eye) : return
