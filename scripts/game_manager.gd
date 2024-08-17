extends Node

@export var enemy_scene: PackedScene  # The scene resource of the enemy
@export var spawn_radius: float = 80.0  # Radius around the target where enemies will spawn
@export var number_of_enemies: int = 1  # Number of enemies to spawn
@export var target: CharacterBody3D  # The target that enemies should move towards
@export var terrain: Terrain = null
@export var scale_variation: float = 0.2  # Variation factor for enemy scale
@export var scale_increment: float = 0.01 # scale increment factor when enemy killed

var pause_menu = preload("res://scenes/UI/Menus/pause_menu.tscn")

var enemies: Array = []
var current_scale: float = 0.12

func _ready():
	spawn_enemies()

func _process(_delta: float) -> void:
	# Handles pausing the game
	if Input.is_action_just_pressed("toggle_pause_menu") and get_tree().paused == false:
		var instance = pause_menu.instantiate()
		add_child(instance)
		get_tree().paused = true

func spawn_enemies():
	for i in range(number_of_enemies):
		var enemy_instance = enemy_scene.instantiate() as CharacterBody3D
		add_child(enemy_instance)  # Add the instance to the scene tree first
		var random_position = get_random_position_near_target()
		enemy_instance.global_transform.origin = random_position
		enemy_instance.scale = get_scaled_enemy()
		enemy_instance.target = target  # Set the target for the enemy
		enemy_instance.connect("enemy_died", Callable(self, "_on_enemy_died"))  # Connect the signal
		enemies.append(enemy_instance)


func get_scaled_enemy() -> Vector3:
	var target_scale = target.scale
	var random_factor = randf_range(1.0 - scale_variation, 1.0 + scale_variation)
	var uniform_scale = Vector3(
		target_scale.x * random_factor,
		target_scale.y * random_factor,
		target_scale.z * random_factor
	)
	return uniform_scale


func get_random_position_near_target() -> Vector3:
	# Access the player's scale_ variable
	# Calculate the adjusted spawn radius
	var adjusted_spawn_radius = spawn_radius * (1 + current_scale)

	var sign_x = sign(randf() - 0.5)
	var sign_z = sign(randf() - 0.5)
	# Generate a random offset based on the adjusted radius
	var random_offset = Vector3(
		max(randf_range(0, adjusted_spawn_radius), 20) * sign_x,
		70,  # Enemies spawn higher than churches (prevents spawning inside buildings)
		max(randf_range(0, adjusted_spawn_radius), 20) * sign_z
	)
	return target.global_transform.origin + random_offset


func _on_enemy_died(enemy_instance: CharacterBody3D):
	enemies.erase(enemy_instance)

	
	var scale_amount = current_scale * scale_increment
	scale_everything(scale_amount)
	
	if enemies.size() == 0:
		spawn_enemies()


func scale_everything(amount: float):
	## Scale world
	# Get the player's position
	var player_pos = target.transform.origin
	
	# Calculate the direction vector from the terrain to the player
	var to_player = terrain.transform.origin - player_pos
	
	# Store the old scale
	var old_scale = terrain.scale
	
	# Scale down the terrain
	terrain.scale -= Vector3.ONE * amount
	
	
	# Calculate the scale ratio (to adjust the terrain position)
	var scale_ratio = terrain.scale / old_scale
	
	# Adjust the terrain's position so it scales towards the player
	terrain.transform.origin = player_pos + to_player * scale_ratio
	
	
	for enemy in enemies:
		enemy.scale * scale_ratio
