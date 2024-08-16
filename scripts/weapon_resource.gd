extends Resource

class_name WeaponResource

@export var name: String
@export var scale: float
@export var model: Resource

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_name="Default", p_scale = 0):
	name = p_name
	scale = p_scale

func is_pickable(playerScale):
	return playerScale >= scale
