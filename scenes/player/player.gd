extends CharacterBody2D

const SPEED = 300.0
const ACCELERATION = 1500.0
const FRICTION = 1000.0

func _physics_process(delta: float) -> void:
	# Получаем направление движения
	var input_direction = Vector2.ZERO
	input_direction.x = Input.get_axis("ui_left", "ui_right")
	input_direction.y = Input.get_axis("ui_up", "ui_down")
	input_direction = input_direction.normalized()
	
	# Применяем ускорение или трение
	if input_direction != Vector2.ZERO:
		velocity = velocity.move_toward(input_direction * SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_slide()
