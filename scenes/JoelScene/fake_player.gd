extends CharacterBody3D

# Variables
@export var speed: float = 15.0
@export var gravity: float = 20.0
@export var radius: float = 10.0
@export var angular_speed: float = 1.0

# Internal variables
var angle: float = 0.0

func _physics_process(delta: float) -> void:
	# Handle gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Calculate new position for circular motion
	angle += angular_speed * delta
	var new_x = radius * cos(angle)
	var new_z = radius * sin(angle)
	var circular_movement = Vector3(new_x, 0.0, new_z)

	# Set the velocity based on circular movement
	velocity.x = circular_movement.x
	velocity.z = circular_movement.z

	# Move the character
	move_and_slide()
