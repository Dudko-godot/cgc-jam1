extends StaticBody2D


@export var can : WateringCan

func _ready() -> void:
	can.clicked.connect(queue_free)
