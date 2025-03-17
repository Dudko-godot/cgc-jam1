extends Control

signal game_completed
signal game_cancelled

const DUST_COUNT = 5
const CLICKS_TO_CLEAN = 3
const DUST_SCALE = 6.0
const DUST_SCALE_REDUCTION = 1
const TV_WIDTH = 400.0
const TV_HEIGHT = 250.0
const MIN_DUST_DISTANCE = 100.0

var dust_pieces = []
var remaining_dust = 0

func _ready():
	mouse_filter = Control.MOUSE_FILTER_PASS
	generate_dust()

func generate_dust():
	var dust_container = $DustContainer
	remaining_dust = DUST_COUNT
	
	for i in range(DUST_COUNT):
		var dust_area = Area2D.new()
		var dust_sprite = Sprite2D.new()
		var collision = CollisionShape2D.new()
		var shape = CircleShape2D.new()
		
		dust_sprite.texture = preload("res://scenes/mini-games/cleanup_tv/dust.png")
		dust_sprite.scale = Vector2(DUST_SCALE, DUST_SCALE)
		
		shape.radius = 30.0
		collision.shape = shape
		
		var position_found = false
		var attempts = 0
		var max_attempts = 10
		var dust_position = Vector2.ZERO
		
		while !position_found and attempts < max_attempts:
			var x = randf_range(-TV_WIDTH/2.0, TV_WIDTH/2.0)
			var y = randf_range(-TV_HEIGHT/2.0, TV_HEIGHT/2.0)
			dust_position = Vector2(x + 400.0, y + 250.0)
			
			position_found = true
			for existing_dust in dust_pieces:
				if dust_position.distance_to(existing_dust.position) < MIN_DUST_DISTANCE:
					position_found = false
					break
			
			attempts += 1
		
		dust_area.position = dust_position
		dust_area.set_meta("clicks", 0)
		dust_area.input_pickable = true
		
		dust_area.mouse_entered.connect(func(): _on_dust_mouse_entered(dust_sprite))
		dust_area.mouse_exited.connect(func(): _on_dust_mouse_exited(dust_sprite))
		dust_area.input_event.connect(func(viewport, event, shape_idx): 
			_on_dust_input_event(viewport, event, shape_idx, dust_area, dust_sprite)
		)
		
		dust_area.add_child(dust_sprite)
		dust_area.add_child(collision)
		dust_container.add_child(dust_area)
		dust_pieces.append(dust_area)

func _on_dust_mouse_entered(dust_sprite):
	dust_sprite.modulate = Color(1.2, 1.2, 1.2)

func _on_dust_mouse_exited(dust_sprite):
	dust_sprite.modulate = Color(1, 1, 1)

func _on_dust_input_event(_viewport, event, _shape_idx, dust_area, dust_sprite):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var clicks = dust_area.get_meta("clicks") + 1
		dust_area.set_meta("clicks", clicks)
		
		if clicks >= CLICKS_TO_CLEAN:
			$DustSound.play()
			dust_area.queue_free()
			dust_pieces.erase(dust_area)
			remaining_dust -= 1
			
			if remaining_dust <= 0:
				complete_game()
		else:
			var new_scale = DUST_SCALE - (DUST_SCALE_REDUCTION * clicks)
			dust_sprite.scale = Vector2(new_scale, new_scale)

func complete_game():
	game_completed.emit()

func cancel_game():
	game_cancelled.emit()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		cancel_game()
