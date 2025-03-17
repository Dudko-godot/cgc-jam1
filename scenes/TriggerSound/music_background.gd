extends Node

var delayBegin = 43.1
var delayBase = 57.6
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Begin.play()
	await get_tree().create_timer(delayBegin).timeout
	$Base.play()
	await get_tree().create_timer(delayBase).timeout
	$Base.stop()
	$End.play()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
