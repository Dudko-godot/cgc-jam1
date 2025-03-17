class_name Tuple extends Resource

#@export var curve : Curve


func fetch_maximum(_phase_ : float) -> Variant:
	return null



func interpolate(default : Variant, phase_ : float) -> Variant:
	var _mapped_weight : float = 0.0
	
	if phase_ > 0.0:
		_mapped_weight = remap(phase_, 0.0, 1.0, 0.0, 1.0)
	else:
		_mapped_weight = remap(phase_, -1.0, 0.0, 1.0, 0.0)
	
	return lerp(default, fetch_maximum(phase_), _mapped_weight)
