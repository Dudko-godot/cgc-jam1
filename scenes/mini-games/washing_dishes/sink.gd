extends Control

signal game_completed
signal game_cancelled

@onready var plate_scene = preload("res://scenes/mini-games/washing_dishes/plate.tscn")
@onready var dirty_container = $DirtyPlatesContainer

var total_plates := 0
var clean_plates := 0

func _ready():
	var num_plates = 6
	total_plates = num_plates
	
	for i in range(num_plates):
		var plate = plate_scene.instantiate()
		dirty_container.add_child(plate)

func check_all_plates_clean():
	clean_plates += 1
	if clean_plates >= total_plates:
		emit_signal("game_completed")
