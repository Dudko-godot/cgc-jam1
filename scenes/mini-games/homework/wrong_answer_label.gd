extends RichTextLabel



func _ready() -> void:
	text = text.format(
		{
			'prompt' : tr('WRONG_ANSWER')
		}
	)
