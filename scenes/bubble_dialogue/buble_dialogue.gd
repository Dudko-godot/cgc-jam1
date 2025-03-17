extends Node2D

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

signal dialogue_finished

func display_text(text: String, duration: float = 2.0) -> void:
	# Устанавливаем текст
	label.text = text
	
	# Запускаем анимацию появления
	animation_player.play("show")
	
	# Запускаем таймер для скрытия
	var timer = get_tree().create_timer(duration)
	timer.timeout.connect(_on_display_timer_timeout)

func _on_display_timer_timeout() -> void:
	# Запускаем анимацию скрытия
	animation_player.play("hide")
	animation_player.animation_finished.connect(_on_hide_finished, CONNECT_ONE_SHOT)

func _on_hide_finished(anim_name: String) -> void:
	if anim_name == "hide":
		dialogue_finished.emit()
		queue_free()
