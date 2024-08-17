extends CharacterBody3D

@export var base_speed: float = 20.0
@export var gravity: float = 20.0
@export var knockback_strength: float = 30.0
@export var knockback_duration: float = 0.5  # Knockback duration in seconds
@export var target: CharacterBody3D
@export var gem_scene: PackedScene

var knockback_timer: float = 0.0
var knockback_velocity: Vector3 = Vector3.ZERO
var in_knockback: bool = false  # Track if the character is currently being knocked back
var health: float = 0  # Health will be set based on the scale value 
var speed: float = base_speed  # Speed will be adjusted based on target's scale_

signal enemy_died

func _ready():
	# Set enemy's health based on its scale 
	health = scale.x

func _physics_process(_delta):
	apply_gravity(_delta)
	move_towards_target(_delta)
	apply_knockback_effect(_delta)
	apply_movement()
	handle_collision()

func apply_gravity(_delta):
	if is_on_floor():
		velocity.y = 0
	else:
		velocity.y -= gravity * _delta

func move_towards_target(_delta):
	if is_on_floor() and target and not in_knockback:
		if "scale_" in target:
			speed = base_speed * target.scale_
		var direction = calculate_direction_to_target(target)
		update_velocity(direction)

func calculate_direction_to_target(target: CharacterBody3D) -> Vector3:
	return (target.global_transform.origin - global_transform.origin).normalized()

func update_velocity(direction: Vector3):
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed

func apply_knockback_effect(_delta):
	if knockback_timer > 0:
		knockback_timer -= _delta
		velocity += knockback_velocity * _delta
		if knockback_timer <= 0:
			knockback_velocity = Vector3.ZERO
			in_knockback = false  # End knockback state

func apply_movement():
	move_and_slide()

func handle_collision():
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider == target and not in_knockback:
			var collision_normal = collision.get_normal()
			# Apply knockback if method exists in target
			if target.has_method('apply_knockback'):
				apply_knockback(collision_normal)
				target.apply_knockback(-collision_normal)
			# Apply damage if method exists in target
			if target.has_method('take_damage'):
				target.take_damage()

func apply_knockback(normal: Vector3):
	# Apply knockback
	knockback_velocity = normal * knockback_strength
	knockback_timer = knockback_duration
	in_knockback = true  # Set knockback state to true

func take_damage(damage: int = 100):
	health -= damage
	if health <= 0:
		#drop_gem()
		emit_signal("enemy_died", self)
		queue_free()
		
#func drop_gem():
	#if gem_scene:
		#var gem_instance = gem_scene.instantiate() as Area3D
		#gem_instance.global_transform.origin = global_transform.origin  # Place the gem where the enemy is
		#get_parent().add_child(gem_instance)  # Add the gem to the scene
