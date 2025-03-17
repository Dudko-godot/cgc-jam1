extends Node


@export var sprite : CoolSprite2D
@export var eye : FatherEye


func _ready() -> void:
	if not(sprite and eye) : return
	if not sprite.character_visuals: return
	_attach.call_deferred()

func _attach() -> void:
	var _visuals = sprite.character_visuals as DadVisuals
	_visuals.stars_hidden.connect(eye.hide_star)
	_visuals.stars_shown.connect(eye.show_star)
	
