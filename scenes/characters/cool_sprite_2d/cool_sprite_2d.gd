class_name CoolSprite2D extends Sprite2D

@export_group('External References')
@export var character_visuals : CharacterVisuals
@export var phase_tracker : PhaseTracker
@export_group('Components')
@export_subgroup('Directional')
#@export var directional_components : Array[DirectionComponent]
@export var direction_component_visibility : DirectionComponentVisibility
@export var direction_component_scale : DirectionComponentScale
@export var direction_component_position : DirectionComponentPosition
@export_subgroup('Phase')
@export var phase_component_position : VectorPhaseComponent
@export var rotation_component_position : FloatPhaseComponent



func _ready() -> void:
	_initialize_all_existing_components()


func _initialize_all_existing_components() -> void:
	_initialize_direction_component(direction_component_visibility)
	_initialize_direction_component(direction_component_scale)
	_initialize_direction_component(direction_component_position)
	
	_initialize_phase_component(phase_component_position)
	_initialize_phase_component(rotation_component_position)

	

func _initialize_direction_component(component_ : DirectionComponent) -> void:
	if not component_ : return
	component_.attach_visuals(character_visuals)
	component_.attach_actor(self)


func _initialize_phase_component(component_ : PhaseComponent) -> void:
	if not component_ : return
	component_.attach_visuals(character_visuals)
	component_.attach_tracker(phase_tracker)
	component_.attach_actor(self)
