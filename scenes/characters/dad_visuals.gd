extends CharacterVisuals

signal stars_shown
signal stars_hidden

func show_stars() -> void:
	stars_shown.emit()


func hide_stars() -> void:
	stars_hidden.emit()
