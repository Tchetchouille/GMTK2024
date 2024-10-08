extends Resource

class_name WeaponResource

@export var name: String
@export var scale: float
@export var model: PackedScene
@export var item_model: PackedScene
@export var max_occurrences: int
@export var radius: float
@export var damage: float

# Make sure that every parameter has a default value.
# Otherwise, there will be problems with creating and editing
# your resource via the inspector.
func _init(p_name="Default", p_scale = 0, p_model=null, p_item_model=null, p_max_occurrences=1, p_radius=1, p_damage=1):
	name = p_name
	scale = p_scale
	model = p_model
	item_model = p_item_model
	max_occurrences = p_max_occurrences
	radius = p_radius
	damage = p_damage

func is_pickable(playerScale):
	return playerScale >= scale
