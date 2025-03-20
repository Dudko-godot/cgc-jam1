class_name Task extends Resource

@export var name : String = ''
@export var description : String = ''

enum STATE {
	INACTIVE,
	PENDING,
	FINISHED
}
