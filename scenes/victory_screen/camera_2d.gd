extends Camera2D

@export var default_size : Vector2 = Vector2.ONE


func _ready() -> void:
	get_viewport().size_changed.connect(_on_viewport_resized, CONNECT_DEFERRED)
	

func _on_viewport_resized() -> void:
	var _zoom : float =  get_viewport().size.x / default_size.x
	zoom = Vector2(_zoom, _zoom)
