extends Node3D

class_name Weapon


#@onready var mesh_instance = $StaticBody3D/MeshInstance3D
@export var resource: WeaponResource:
	get:
		return resource
	set(value):
		resource = value
		set_resource(value)

func set_resource(res: WeaponResource):
	#await self.ready
	var model = res.model.instantiate()
	add_child(model)

func pick_up():
	# Function to be called by character when picking up this weapon
	# from the ground.
	call_deferred("queue_free")
	return resource
