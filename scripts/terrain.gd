extends Node3D

class_name Terrain

@export var map_size = 100
@export var player: CharacterBody3D
var weapon_template = preload("res://scenes/weapon.tscn")
#@onready var noise: FastNoiseLite = FastNoiseLite.new()
var taken_spaces = Array()

var weapons: Array[WeaponResource] = [
	#preload("res://resources/mountain.tres"),
	preload("res://resources/weapons/church.tres"),
	#preload("res://resources/bone.tres"),
	preload("res://resources/weapons/sword.tres"),
	#preload("res://resources/weapons/chair.tres"),
	preload("res://resources/weapons/needle.tres"),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#noise.seed = randi()
	
	# Prevent stuff from spawning at the center (on the player)
	taken_spaces.append({
		"pos": Vector2(0, 0),
		"r": 5
	})

	# scale as if the character was 12cm high
	#scale = 10 * Vector3.ONE

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

			#print("Add weapon" + weapon_resource.name)
			add_weapon(weapon_resource, Vector3(x, 0, y))
			
			taken_spaces.append(new_space)

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
