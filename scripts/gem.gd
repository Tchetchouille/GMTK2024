extends Area3D

class_name Gem

var hover_speed = 1
var rotation_speed = 50
var original_scale: float = 1

@onready var mesh = $MeshInstance3D

var hover_time = 0

func _ready():
	hover_time = randf_range(0, 2 * PI)  # Start at a random point in the hover cycle

func _physics_process(delta: float) -> void:
	hover_time += delta * hover_speed
	mesh.transform.origin.y = cos(hover_time) * 0.5 + 0.5
	
	mesh.transform.basis = mesh.transform.basis.rotated(Vector3.UP, deg_to_rad(delta * rotation_speed))

func pick_up():
	queue_free()
	return 1
