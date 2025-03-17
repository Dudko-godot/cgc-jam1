extends Node2D

const DEFEAT = preload('res://scenes/defeat_screen/defeat_screen.tscn')

@export var dialogue_text: String = ""
@export var point_name: String = ""
@export_enum("None", "Talk", "Watch", "Drink") var action_type: int = 0
@export var dialogue_duration: float = 2.0
@export var min_action_duration: float = 1.0  # Минимальная длительность действия
@export var max_action_duration: float = 3.0  # Максимальная длительность действия

signal action_finished

@onready var action_timer: Timer = $ActionTimer
var rng = RandomNumberGenerator.new()

# Прегружаем сцену диалога
const DialogueBubble = preload("res://scenes/bubble_dialogue/buble_dialogue.tscn")

func _ready():
	rng.randomize()
	
	# Устанавливаем начальную длительность действия
	action_timer.wait_time = min_action_duration
	action_timer.one_shot = true
	
	if not action_timer.is_connected("timeout", Callable(self, "_on_action_timer_timeout")):
		action_timer.connect("timeout", Callable(self, "_on_action_timer_timeout"))

func trigger_action(character: Node2D) -> void:
	if action_type == 0: # None
		get_tree().change_scene_to_packed(DEFEAT)
		action_finished.emit()
		return
		
	# Устанавливаем случайную длительность действия
	action_timer.wait_time = rng.randf_range(min_action_duration, max_action_duration)
	
	if dialogue_text:
		# Создаем диалоговый пузырь
		var bubble = DialogueBubble.instantiate()
		character.add_child(bubble)
		# Подключаем сигнал завершения диалога
		bubble.dialogue_finished.connect(_on_dialogue_finished)
		# Показываем текст
		bubble.display_text(dialogue_text, dialogue_duration)
	else:
		# Если нет текста, сразу запускаем таймер действия
		action_timer.start()

func _on_dialogue_finished() -> void:
	# Диалог закончился, запускаем таймер действия
	action_timer.start()

func _on_action_timer_timeout() -> void:
	action_finished.emit() 
