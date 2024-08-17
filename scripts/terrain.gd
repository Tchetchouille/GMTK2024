extends Node3D

class_name Terrain

var weapon_template = preload("res://scenes/weapon.tscn")
var noise: FastNoiseLite

var weapons: Array = [
	preload("res://resources/mountain.tres"),
	preload("res://resources/church.tres"),
	preload("res://resources/bone.tres"),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	noise = FastNoiseLite.new()

	# Configure
	noise.seed = randi()

	for x in range(100):
		for y in range(100):
			var val = noise.get_noise_2d(x, y)

			if val > 0.4:
				print(val)
				add_weapon(weapons[1], Vector3(x, val*10, y))

	#for weapon_resource in weapons:
		#add_weapon(weapon_resource, Vector2(0, -2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_weapon(weapon_resource: WeaponResource, position: Vector3):
	var weapon = weapon_template.instantiate()

	# Register the node and have it run its _ready()
	add_child(weapon)

	weapon.position.x = position.x
	weapon.position.y = position.y
	weapon.position.z = position.z
	weapon.resource = weapon_resource
