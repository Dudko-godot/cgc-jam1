extends Node

@export_range(0.0, 180.0, 0.1) var amplitude : float = 2.0
@export_range(0.0, 10.0, 0.1) var duration : float = 1.0

@export var camera : TweenedCamera
@export var tween_component : TweenComponent

func _ready() -> void:
	camera.started_outro.connect(_on_outro_started)
	
	tween_component.refresh_tween(Tween.EASE_IN_OUT, Tween.TRANS_SINE)
	
	tween_component.tween.tween_property(
		camera, 'rotation_degrees', -amplitude * 0.5 , duration
	)
	tween_component.tween.tween_property(
		camera, 'rotation_degrees', amplitude * 0.5 , duration
	)
	tween_component.tween.set_loops(0)


func _on_outro_started() -> void:
	tween_component.tween.kill()
