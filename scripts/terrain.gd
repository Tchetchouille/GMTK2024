extends Node3D

class_name Terrain

var weapon_template = preload("res://scenes/weapon.tscn")

var weapons: Array = [
	preload("res://resources/bone.tres"),
	preload("res://resources/church.tres"),
	preload("res://resources/mountain.tres"),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for weapon_resource in weapons:
		var weapon = weapon_template.instantiate()
		add_child(weapon)
		weapon.set_resource(weapon_resource)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
