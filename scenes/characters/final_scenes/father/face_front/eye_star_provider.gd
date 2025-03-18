extends Node

@export var sprite : CoolSprite2D
@export var animation_player : AnimationPlayer

func _ready() -> void:
	if not (sprite and animation_player) : return
	if not sprite.character_visuals: return
	_attach.call_deferred()


func _attach() -> void:
	var _visuals = sprite.character_visuals as FatherVisuals
	_visuals.angered.connect(_on_anger_enterd)
	_visuals.becalmed.connect(_on_anger_left)


func _on_anger_enterd() -> void:
	animation_player.play('to_anger')


func _on_anger_left() -> void:
	animation_player.play('to_mild')
