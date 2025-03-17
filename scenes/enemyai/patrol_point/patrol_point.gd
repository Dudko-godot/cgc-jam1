extends Node2D

@export var dialogue_text: String = ""
@export var point_name: String = ""
@export_enum("None", "Talk", "Watch", "Drink") var action_type: int = 0
@export var dialogue_duration: float = 2.0
@export var action_duration: float = 1.0  # Длительность действия после диалога

signal action_finished

@onready var action_timer: Timer = $ActionTimer

# Прегружаем сцену диалога
const DialogueBubble = preload("res://scenes/bubble_dialogue/buble_dialogue.tscn")

func _ready():
	# Убедимся, что таймер настроен правильно
	if not action_timer:
		push_error("ActionTimer не найден в ", name)
		return
	
	# Устанавливаем длительность действия
	action_timer.wait_time = action_duration
	action_timer.one_shot = true
	
	if not action_timer.is_connected("timeout", Callable(self, "_on_action_timer_timeout")):
		action_timer.connect("timeout", Callable(self, "_on_action_timer_timeout"))

func trigger_action(character: Node2D) -> void:
	print(name, ": начало действия")
	if action_type == 0: # None
		print(name, ": нет действия, сразу завершаем")
		action_finished.emit()
		return
		
	if dialogue_text:
		print(name, ": показываем диалог")
		# Создаем диалоговый пузырь
		var bubble = DialogueBubble.instantiate()
		character.add_child(bubble)
		# Подключаем сигнал завершения диалога
		bubble.dialogue_finished.connect(_on_dialogue_finished)
		# Показываем текст
		bubble.display_text(dialogue_text, dialogue_duration)
	else:
		print(name, ": нет диалога, запускаем действие")
		# Если нет текста, сразу запускаем таймер действия
		action_timer.start()

func _on_dialogue_finished() -> void:
	print(name, ": диалог завершеввн, запускаем действие")
	# Диалог закончился, запускаем таймер действия
	action_timer.start()

func _on_action_timer_timeout() -> void:
	print(name, ": действие завершено, эмитим сигнал")
	action_finished.emit() 
