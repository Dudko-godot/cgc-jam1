class_name VectorTuple extends Tuple

@export var positive_maximim : Vector2
@export var negative_maximum : Vector2


func fetch_maximum(phase_ : float) -> Vector2:
	if phase_ > 0.0:
		return positive_maximim
	else:
		return negative_maximum
