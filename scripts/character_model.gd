class_name CharacterModel extends Node3D

@export var hand: Node3D

func set_hand_item(item: PackedScene):
	var instance = item.instantiate()
	hand.add_child(instance)

func set_hand_item_scale(scale: Vector3):
	var item = hand.get_child(0)
	if item:
		item.scale = scale
	else:
		printerr("Hand item doesn't exist")
