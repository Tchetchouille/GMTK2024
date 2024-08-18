class_name GameManager extends Node

@export var enemy_scene: PackedScene  # The scene resource of the enemy
@export var spawn_radius: float = 80.0  # Radius around the target where enemies will spawn
@export var number_of_enemies: int = 1  # Number of enemies to spawn
@export var target: CharacterBody3D  # The target that enemies should move towards
@export var terrain: Terrain = null
@export var scale_variation: float = 0.2  # Variation factor for enemy scale
@export var scale_increment: float = 0.001 # scale increment factor when enemy killed
@export var start_scale: float = 0.05
@export var time_between_waves: float = 10

var pause_menu = preload("res://scenes/UI/Menus/pause_menu.tscn")

var enemies: Array = []
var current_scale: float = 1.0 / start_scale
var current_simulated_player_scale : float = start_scale

func _ready():
	spawn_enemies()
	
	# initial scaling
	scale_everything(current_scale, 0)

	## Wave timer
	var timer = Timer.new()
	timer.wait_time = time_between_waves
	timer.one_shot = false 
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	add_child(timer)

	timer.start()


func _on_Timer_timeout():
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

		# Position the enemy around the target
		var random_position = get_random_position_near_target()
		enemy_instance.transform.origin = random_position

		# Add the enemy to the scene
		add_child(enemy_instance)

		# Scale the enemy relative to the player's current scale (make it around the player's size)
		var relative_scale = randf_range(1.0 - scale_variation, 1.0)

		enemy_instance.health = relative_scale * current_simulated_player_scale
		enemy_instance.scale = Vector3.ONE * relative_scale

		# Set the target for the enemy
		enemy_instance.target = target

		# Connect the enemy's death signal
		enemy_instance.connect("enemy_died", Callable(self, "_on_enemy_died"))

		# Track the enemy instance
		enemies.append(enemy_instance)

func get_random_position_near_target() -> Vector3:
	# Access the player's scale_ variable
	# Calculate the adjusted spawn radius
	var adjusted_spawn_radius = max(spawn_radius * current_simulated_player_scale, 20)

	var sign_x = sign(randf() - 0.5)
	var sign_z = sign(randf() - 0.5)
	# Generate a random offset based on the adjusted radius
	var random_offset = Vector3(
		max(randf_range(0, adjusted_spawn_radius), 10) * sign_x,
		70,  # Enemies spawn higher than churches (prevents spawning inside buildings)
		max(randf_range(0, adjusted_spawn_radius), 10) * sign_z
	)
	return target.transform.origin + random_offset


func _on_enemy_died(enemy_instance: CharacterBody3D):
	enemies.erase(enemy_instance)
	
	# Increment the player scale
	# This is probably bad.
	current_simulated_player_scale += scale_increment
	
	if current_simulated_player_scale >= 12:
		print("WIN !")
		current_simulated_player_scale = 12

	current_scale = 1.0 / current_simulated_player_scale
	print("current_scale: ", current_scale, "; csps: ", current_simulated_player_scale)
	
	# Scale everything (terrain, enemies, player's weapon) based on the new scale
	scale_everything(current_scale, scale_increment)
	
	if enemies.size() <= 1:
		spawn_enemies()


func scale_everything(scale_value, scale_increment):
	var scale_vector = scale_value * Vector3.ONE
	print("Scaling terrain to: ", scale_vector)
	
	## Scale world (terrain)
	var player_pos = target.transform.origin
	var to_player = terrain.transform.origin - player_pos
	var old_scale = terrain.scale
	terrain.scale = scale_vector
	var scale_ratio = terrain.scale / old_scale
	terrain.transform.origin = player_pos + to_player * scale_ratio
	
	## Scale enemies
	for enemy in enemies:
		# Adjust the enemy's scale based on the increment THIS DOESN'T WORK
		var original_scale = enemy.scale / scale_vector
		enemy.scale -= original_scale * scale_increment

		if enemy.scale.x <= 0:
			enemies.erase(enemy)
			enemy.queue_free()
	
	## Scale the weapon in hand
	target.model.set_hand_item_scale(scale_vector)
