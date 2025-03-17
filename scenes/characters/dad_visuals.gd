class_name DadVisuals extends CharacterVisuals

signal stars_shown
signal stars_hidden

func show_stars() -> void:
	stars_shown.emit()


func hide_stars() -> void:
	stars_hidden.emit()

func _ready() -> void:
	await get_tree().create_timer(3.0).timeout
	show_stars()
