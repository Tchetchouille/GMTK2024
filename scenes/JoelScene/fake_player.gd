extends CharacterBody3D

# Variables
@export var speed: float = 15.0
@export var gravity: float = 20.0
@export var radius: float = 10.0
@export var angular_speed: float = 1.0
@export var knockback_strength: float = 10.0
@export var knockback_duration: float = 0.5

# Internal variables
var angle: float = 0.0
var knockback_timer: float = 0.0
var knockback_velocity: Vector3 = Vector3.ZERO
var in_knockback: bool = false  # Track if the character is currently being knocked back

func apply_knockback_effect(_delta):
	if knockback_timer > 0:
		knockback_timer -= _delta
		print("Applying knockback: ", knockback_velocity, " Timer: ", knockback_timer)
		velocity += knockback_velocity * _delta
		if knockback_timer <= 0:
			print("Knockback effect ended.")
			knockback_velocity = Vector3.ZERO
			in_knockback = false  # End knockback state

func apply_knockback(normal: Vector3):
	# Apply knockback
	knockback_velocity = normal * knockback_strength
	knockback_timer = knockback_duration
	in_knockback = true  # Set knockback state to true
	print("Knockback applied with velocity: ", knockback_velocity, " Duration: ", knockback_timer)

func _physics_process(delta: float) -> void:
	apply_knockback_effect(delta)
	
	# Handle gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Only apply circular motion if not in knockback
	if not in_knockback:
		angle += angular_speed * delta
		var new_x = radius * cos(angle)
		var new_z = radius * sin(angle)
		var circular_movement = Vector3(new_x, 0.0, new_z)

		# Set the velocity based on circular movement
		velocity.x = circular_movement.x
		velocity.z = circular_movement.z
	else:
		print("In knockback, circular motion paused.")

	# Move the character
	move_and_slide()
