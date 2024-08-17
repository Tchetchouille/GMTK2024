extends Node3D

class_name Weapon


@onready var mesh_instance = $StaticBody3D/MeshInstance3D
@export var resource: WeaponResource:
	get:
		return resource
	set(value):
		set_resource(value)

func set_resource(res: WeaponResource):
	await self.ready
	mesh_instance.mesh = res.model

	# create collision shape from the mesh
	mesh_instance.create_trimesh_collision()

func pick_up():
	# Function to be called by character when picking up this weapon
	# from the ground.
	queue_free()
	return resource
