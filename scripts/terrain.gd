extends Node3D

class_name Terrain

@export var map_size = 100
var weapon_template = preload("res://scenes/weapon.tscn")
var noise: FastNoiseLite

var weapons: Array[WeaponResource] = [
	#preload("res://resources/mountain.tres"),
	preload("res://resources/weapons/church.tres"),
	#preload("res://resources/bone.tres"),
	preload("res://resources/weapons/sword.tres"),
	preload("res://resources/weapons/chair.tres"),
	preload("res://resources/weapons/needle.tres"),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#noise = FastNoiseLite.new()
	#noise.seed = randi()

	var taken_spaces = Array()
	for weapon_resource in weapons:
		for _i in range(weapon_resource.max_occurrences):
			var x = randi() % map_size - map_size / 2
			var y = randi() % map_size - map_size / 2

			var new_space = {
				"pos": Vector2(x, y),
				"r": weapon_resource.radius
			}

			var is_overlapped = false
			for space in taken_spaces:
				if is_overlap(space, new_space):
					is_overlapped = true;
					break;
			
			if is_overlapped:
				continue

			print("Add weapon" + weapon_resource.name)
			add_weapon(weapon_resource, Vector3(x, 0, y))
			
			taken_spaces.append(new_space)
	#for x in range(100):
		#for y in range(100):
			#var val = noise.get_noise_2d(x, y)
#
			#if val > 0.4:
				#print(val)
				#add_weapon(weapons[1], Vector3(x, val*10, y))


func add_weapon(weapon_resource: WeaponResource, position: Vector3):
	var weapon = weapon_template.instantiate()

	# Register the node and have it run its _ready()
	add_child(weapon)

	weapon.position.x = position.x
	weapon.position.y = position.y
	weapon.position.z = position.z
	weapon.resource = weapon_resource

func is_overlap(a, b):
	var dist = a.pos.distance_to(b.pos)
	return dist < a.r + b.r
