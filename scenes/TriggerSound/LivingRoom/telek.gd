extends StaticBody2D

@export var stream_player : AudioStreamPlayer2D



func _ready() -> void:
	stream_player.finished.connect(_play_from_random)
	_play_from_random()

func _play_from_random() -> void:
	randomize()
	stream_player.play(randf() * stream_player.stream.get_length())
