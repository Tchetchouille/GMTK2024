extends Resource

class_name WeaponResource

@export var name: String
@export var scale: float
@export var model: PackedScene
@export var max_occurrences: int
@export var radius: float

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_model=null, p_name="Default", p_scale = 0, p_max_occurrences=1, p_radius=1):
	name = p_name
	scale = p_scale
	model = p_model
	max_occurrences = p_max_occurrences
	radius = p_radius

func is_pickable(playerScale):
	return playerScale >= scale
