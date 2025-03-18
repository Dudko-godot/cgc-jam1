class_name TweenComponent extends Node

const TRANS_DEFAULT : Tween.TransitionType = Tween.TRANS_QUAD
const EASE_DEFAULT : Tween.EaseType = Tween.EASE_OUT

var tween : Tween


func refresh_tween() -> void:
	if tween: tween.kill()
	tween = create_tween().set_trans(TRANS_DEFAULT).set_ease(EASE_DEFAULT)
