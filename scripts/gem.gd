extends Area3D

class_name Gem

var hover_speed = 1
var rotation_speed = 50
var original_scale = 1
var rotation_amount = 0

func _ready():
	rotation_amount = randf_range(0, 360)

func _process(delta: float) -> void:
	transform.origin.y = cos(delta * hover_speed) + 0.5
	rotation_amount += delta * rotation_speed
	transform.basis.rotated(Vector3.UP, rotation_amount)

func pick_up():
	queue_free()
	return 1
