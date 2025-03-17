class_name CoolSprite2D extends Sprite2D

@export_group('External References')
@export var character_visuals : CharacterVisuals
@export_group('Components')
#@export var directional_components : Array[DirectionComponent]
@export var direction_component_visibility : DirectionComponentVisibility
@export var direction_component_scale : DirectionComponentScale
@export var direction_component_position : DirectionComponentPosition



func _ready() -> void:
	_initialize_all_existing_components()


func _initialize_all_existing_components() -> void:
	_initialize_direction_component(direction_component_visibility)
	_initialize_direction_component(direction_component_scale)
	_initialize_direction_component(direction_component_position)
	#for _component : DirectionComponent in directional_components:
		#_component.
	##_initialize_direction_component(direction_component_visibility)
	
	

func _initialize_direction_component(component_ : DirectionComponent) -> void:
	if not component_ : return
	component_.attach_visuals(character_visuals)
	component_.attach_actor(self)
	
	#if component_ is DirectionComponentVisibility:
		#_initialize_visibility_component(component_)
		#return
#
#func _initialize_visibility_component(component_ : DirectionComponentVisibility) -> void:
	#component_.show.connect(show)
	#component_.hide.connect(hide)


#func _initialize_phase_component(component_ : DirectionComponent = direction_component) -> void:
	#pass
