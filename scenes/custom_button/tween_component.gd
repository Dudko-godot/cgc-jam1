class_name TweenComponent extends Node

const TRANS_DEFAULT : Tween.TransitionType = Tween.TRANS_QUAD
const EASE_DEFAULT : Tween.EaseType = Tween.EASE_OUT

var tween : Tween



func refresh_tween(
	ease_ : Tween.EaseType = EASE_DEFAULT,
	trans_ :  Tween.TransitionType = TRANS_DEFAULT ) -> void:
	if tween: tween.kill()
	tween = create_tween().set_trans(trans_).set_ease(ease_)
