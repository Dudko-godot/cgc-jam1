extends Node

@export var enemy: Node2D
@export var target_nodes: Array[NodePath] = []

@onready var target_switch_timer: Timer = $Timer
var resolved_targets: Array[Node2D] = []

func _ready():
	# Преобразуем NodePath в реальные узлы
	for path in target_nodes:
		var node = get_node(path)
		if node:
			resolved_targets.append(node)
	
	# Убедитесь, что у нас есть враг и цели
	if not enemy or resolved_targets.is_empty():
		print("Ошибка: Убедитесь, что враг и цели заданы.")
		return

func _on_timer_timeout() -> void:
	# Получаем текущий индекс цели
	var current_target_index = resolved_targets.find(enemy.target_node)
	# Вычисляем следующий индекс
	var next_target_index = (current_target_index + 1) % resolved_targets.size()
	# Устанавливаем новую цель
	var new_target = resolved_targets[next_target_index]
	enemy.emit_signal("target_changed", new_target)
	print("Переключение цели на: ", new_target.name)
