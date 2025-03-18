extends Node

@export var controller : EnemyAIController
@export var father_enemy : Node2D

var father_visuals : FatherVisuals

func _ready() -> void:
	father_visuals = father_enemy.get_node('FatherVisuals')
	
	controller.began_actively_chasing_player.connect(_on_began)
	controller.stopped_actively_chasing_player.connect(_on_stopped)


func _on_stopped() -> void:
	father_visuals.becalm()
	#print('Father has calmed down')
	
func _on_began() -> void:
	father_visuals.anger()
	#print('Father is coming for you!')
