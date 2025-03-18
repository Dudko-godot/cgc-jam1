extends RigidBody2D

const REPULSION_FORCE = 200.0  # Уменьшили с 500 до 200
const REPULSION_RADIUS = 50.0  # Радиус действия метлы



func _physics_process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_pos = get_global_mouse_position()
		var distance = global_position.distance_to(mouse_pos)
		
		if distance < REPULSION_RADIUS:
			# Вычисляем вектор отталкивания
			var direction = (global_position - mouse_pos).normalized()
			# Сила отталкивания обратно пропорциональна расстоянию
			var force = direction * REPULSION_FORCE * (1.0 - distance / REPULSION_RADIUS)
			apply_central_impulse(force) 



func _ready() -> void:
	var rotation_amp : float = 60.0
	var scale_amp : float = 0.2
	
	randomize()
	rotation_degrees = (randf() - 0.5) * rotation_amp
	
	randomize()
	var _scale_uniform : float = (randf() - 0.5) * scale_amp
	scale = Vector2(_scale_uniform, _scale_uniform)
