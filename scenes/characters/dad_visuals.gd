class_name FatherVisuals extends CharacterVisuals

signal angered
signal becalmed


func anger() -> void:
	angered.emit()


func becalm() -> void:
	becalmed.emit()
