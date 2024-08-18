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
var gems_on_terrain: Array = []
var current_scale: float = 1.0 / start_scale
var current_simulated_player_scale : float = start_scale

# Scale lerping
var is_scaling: bool = false
var scale_start: Vector3
var scale_target: Vector3
var scale_duration: float = 0.5  # Duration for the interpolation
var scale_elapsed_time: float = 0.0


func _ready():
	target.connect("gem_picked_up", Callable(self, "_on_gem_picked_up"))
	spawn_enemies()

	# initial scaling
	scale_everything(current_scale)

	## Wave timer
	var timer = Timer.new()
	timer.wait_time = time_between_waves
	timer.one_shot = false 
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	add_child(timer)

	timer.start()


func _on_Timer_timeout():
	spawn_enemies()
	

func _process(delta: float) -> void:
	# Handles pausing the game
	if Input.is_action_just_pressed("toggle_pause_menu") and get_tree().paused == false:
		var instance = pause_menu.instantiate()
		add_child(instance)
		get_tree().paused = true
	
	if is_scaling:
		scale_elapsed_time += delta
		var t = clamp(scale_elapsed_time / scale_duration, 0.0, 1.0)

		# Lerp the scale
		var new_scale = lerp_vector(scale_start, scale_target, t)

		# Apply the new scale to the terrain
		var player_pos = target.transform.origin
		var to_player = terrain.transform.origin - player_pos
		var old_scale = terrain.scale
		terrain.scale = new_scale
		var scale_ratio = terrain.scale / old_scale
		terrain.transform.origin = lerp_vector(terrain.transform.origin, player_pos + to_player * scale_ratio, t)

		# Lerp and apply the new scale to all enemies
		for enemy in enemies:
			var old_enemy_scale = enemy.scale
			enemy.scale = lerp_vector(old_enemy_scale, enemy.original_scale * new_scale, t)
			# Threshold for removing tiny enemies
			if enemy.scale.x <= 0.01:
				enemies.erase(enemy)
				enemy.queue_free()

		# Lerp and apply the new scale to the weapon in hand
		var old_hand_item_scale = target.model.get_hand_item_scale()
		target.model.set_hand_item_scale(lerp_vector(old_hand_item_scale, new_scale, t))

		for gem in gems_on_terrain:
			var old_gem_scale = gem.scale
			gem.scale = lerp_vector(old_gem_scale, gem.original_scale * new_scale, t)
			
			if gem.scale.x <= 0.01:
				gems_on_terrain.erase(gem)
				gem.queue_free()
		# Stop scaling when done
		if t >= 1.0:
			is_scaling = false

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

		enemy_instance.original_scale = relative_scale * current_simulated_player_scale
		enemy_instance.health = enemy_instance.original_scale
		enemy_instance.scale = Vector3.ONE * relative_scale

		# Set the target for the enemy
		enemy_instance.target = target

		# Connect the enemy's death signal
		enemy_instance.connect("enemy_died", Callable(self, "_on_enemy_died"))
		enemy_instance.connect("gem_dropped", Callable(self, "_on_gem_dropped"))

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
	
	if enemies.size() <= 1:
		spawn_enemies()

func _on_gem_dropped(gem: Gem):
	gems_on_terrain.append(gem)

func _on_gem_picked_up(gem: Gem):
	gems_on_terrain.erase(gem)
	var gem_scale = gem.original_scale
	var increment = gem.pick_up()
	
	# Increment the player scale
	# This is probably bad.
	var scale_value = scale_increment * gem_scale * 10
	current_simulated_player_scale += scale_value
	
	target.health += gem_scale
	
	if target.health > 100:
		target.health = 100

	if current_simulated_player_scale >= 12:
		$"../GeneralUI/VictoryScreen".show()
		current_simulated_player_scale = 12

	current_scale = 1.0 / current_simulated_player_scale
	print("current_scale: ", current_scale, "; csps: ", current_simulated_player_scale)
	
	# Scale everything (terrain, enemies, player's weapon) based on the new scale
	scale_everything(current_scale)

func scale_everything(target_scale_value: float):
	# Set up the scaling operation
	scale_start = terrain.scale
	scale_target = target_scale_value * Vector3.ONE
	scale_elapsed_time = 0.0
	is_scaling = true


func lerp_vector(v1: Vector3, v2: Vector3, t: float) -> Vector3:
	return Vector3(
		lerp(v1.x, v2.x, t),
		lerp(v1.y, v2.y, t),
		lerp(v1.z, v2.z, t)
	)
