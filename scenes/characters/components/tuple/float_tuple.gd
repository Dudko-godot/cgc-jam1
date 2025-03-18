class_name FloatTuple extends Tuple

@export var positive_maximim : float = 0.0
@export var negative_maximum : float = 0.0


func fetch_maximum(phase_ : float) -> float:
	#print('Fetching')
	if phase_ > 0.0:
		return positive_maximim
	else:
		return negative_maximum
