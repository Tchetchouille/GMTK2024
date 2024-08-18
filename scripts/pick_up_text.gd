extends Label3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

# TO ADD TO CHARACTER
#func picking_up_ui(offset):
	#if picking_up_weapon:
		#var weapon_name = picking_up_weapon.resource.name
		#var weapon_pos = picking_up_weapon.resource
		#print("Weapon is " + weapon_pos)
		#pick_up_ui.text = "Click repeatedly to pick up " + weapon_name + "."
		#pick_up_ui.position = picking_up_weapon.position + offset
