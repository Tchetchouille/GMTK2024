extends CharacterBody3D

@export var speed: float = 10.0
@export var gravity: float = 20.0
@onready var fake_player: CharacterBody3D = $"../FakePlayer"

func _physics_process(_delta):
	apply_gravity(_delta)
	move_towards_target(_delta)
	apply_movement()

#  handle gravity
func apply_gravity(_delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity * _delta

# calculate direction towards the target and update velocity
func move_towards_target(_delta):
	if fake_player:
		var direction = calculate_direction_to_target(fake_player)
		update_velocity(direction)

# Function to calculate the direction vector to the target
func calculate_direction_to_target(target: CharacterBody3D) -> Vector3:
	return (target.global_transform.origin - global_transform.origin).normalized()

# Function to update the velocity based on direction
func update_velocity(direction: Vector3):
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	# Uncomment this line if movement in the Y axis is needed
	# velocity.y = direction.y * speed

# apply movement using move_and_slide
func apply_movement():
	move_and_slide()
