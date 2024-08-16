extends Node3D

class_name Weapon


@onready var mesh_instance = $StaticBody3D/MeshInstance3D

func set_resource(res: WeaponResource):
	mesh_instance.mesh = res.model

	# create collision shape from the mesh
	mesh_instance.create_trimesh_collision()

func pick_up():
	# Function to be called by character when picking up this weapon
	# from the ground.
	pass
