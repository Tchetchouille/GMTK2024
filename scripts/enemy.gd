extends CharacterBody3D

@export var speed: float = 20.0
@export var gravity: float = 20.0
@export var knockback_strength: float = 30.0
@export var knockback_duration: float = 2.0
@export var target : CharacterBody3D


func _physics_process(_delta):
	apply_gravity(_delta)
	move_towards_target(_delta)
	apply_movement()
	handle_collision()

func apply_gravity(_delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity * _delta

func move_towards_target(_delta):
	if target:
		var direction = calculate_direction_to_target(target)
		update_velocity(direction)

func calculate_direction_to_target(target: CharacterBody3D) -> Vector3:
	return (target.global_transform.origin - global_transform.origin).normalized()

func update_velocity(direction: Vector3):
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

func apply_movement():
	move_and_slide()

func handle_collision():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_collider() == target:
			var collision_normal = collision.get_normal()
			apply_knockback(collision_normal)
			target.apply_knockback(-collision_normal)

func apply_knockback(normal: Vector3):
	velocity += normal * knockback_strength
	await get_tree().create_timer(knockback_duration).timeout
	velocity = Vector3.ZERO
