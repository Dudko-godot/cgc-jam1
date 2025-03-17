class_name FatherEye extends Node2D

@onready var star: Node2D = $Star
	
func show_star() -> void:
	star.show()


func hide_star() -> void:
	star.hide()
