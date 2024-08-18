extends CharacterBody3D

@export var health: float = 100
@export var speed = 10.0
@export var inactivity_pickup_loss: float = 10
@export var current_weapon_resource: WeaponResource
@export var knockback_strength: float = 100.0
@export var knockback_duration: float = 0.5
@export var pickup_increment: float = 10
@export var model: CharacterModel
@export var manager: GameManager

@onready var mouse_sensitivity = 0.01 #get_var("look-sensitivity")
@onready var camera = $CharacterCamera3D

signal gem_picked_up

var target_velocity = Vector3.ZERO
var weapons_in_range = []
var is_picking_up = false
var pickup_progress: float = 0
var picking_up_weapon = null
var knockback_timer: float = 0.0
var knockback_velocity: Vector3 = Vector3.ZERO
var in_knockback: bool = false  # Track if the character is currently being knocked back

# https://kidscancode.org/godot_recipes/4.x/input/mouse_capture/
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	model.set_hand_item(current_weapon_resource.item_model)
	model.set_hand_item_scale(manager.current_scale * Vector3.ONE)

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if is_picking_up:
		if Input.is_action_just_pressed("click_action") :
			pickup_progress += pickup_increment
			camera.trauma += 0.08
			print(pickup_progress)
			if pickup_progress > 100:
				camera.trauma += 0.2
				current_weapon_resource = picking_up_weapon.pick_up()
				pickup_progress = 0
				picking_up_weapon = null
				is_picking_up = false
				print("Weapon picked up!")
				model.set_hand_item(current_weapon_resource.item_model)
				model.set_hand_item_scale(manager.current_scale * Vector3.ONE)
		else:
			# loose progress if not clicking
			pickup_progress -= inactivity_pickup_loss * delta
			if pickup_progress < 0:
				pickup_progress = 0
				picking_up_weapon = null
				is_picking_up = false

		# Don't continue with the rest of the inputs
		return
	
	if Input.is_action_pressed("move_forward") :
		direction.z -= 1
	if Input.is_action_pressed("move_back") :
		direction.z += 1
	if Input.is_action_pressed("move_right") :
		direction.x += 1
	if Input.is_action_pressed("move_left") :
		direction.x -= 1
		
	if Input.is_action_just_pressed("click_action") :
		if weapons_in_range :
			pickup_weapon()
		else :
			attack()

	var movement_dir = transform.basis * Vector3(direction.x, 0, direction.z)

	if direction != Vector3.ZERO :
		direction = direction.normalized()
		
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	
	# Walking sound logic
	if direction != Vector3.ZERO:
		if not $WalkingSound.playing:
			$WalkingSound.play()
	else:
		if $WalkingSound.playing:
			$WalkingSound.stop()
	
	apply_knockback_effect(delta)
	move_and_slide()
	model.set_hand_item_scale(manager.current_scale * Vector3.ONE)
	
	var overlapping_areas = $PickupArea.get_overlapping_areas()
	if overlapping_areas:
		for area in overlapping_areas:
			if area is Gem:
				var gem = area as Gem
				emit_signal("gem_picked_up", gem)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

func apply_knockback_effect(_delta):
	if knockback_timer > 0:
		knockback_timer -= _delta
		velocity += knockback_velocity * _delta
		if knockback_timer <= 0:
			knockback_velocity = Vector3.ZERO
			in_knockback = false  # End knockback state

func apply_knockback(normal: Vector3):
	# Apply knockback
	knockback_velocity = normal * knockback_strength
	knockback_timer = knockback_duration
	in_knockback = true  # Set knockback state to true

func _on_collision_area_body_entered(body):
	#print("Entered")
	var weapon = body.get_parent().get_parent()
	if weapon is Weapon :
		#print("Entered weapon")
		weapons_in_range.append(weapon)

func _on_collision_area_body_exited(body):
	#print("Exited")
	var weapon = body.get_parent().get_parent()
	if weapon is Weapon :
		#print("Exited weapon")
		weapons_in_range.erase(weapon)

func pickup_weapon() :
	var min_distance = INF
	var min_scale = INF
	var closest_weapon = null
	var biggest_weapon = null
	var eligible_weapons = 0
	for body in $PickupArea.get_overlapping_bodies():
		if body.get_parent().get_parent() is not Weapon: continue
		var weapon = body.get_parent().get_parent() as Weapon
		
		#if weapon.resource.scale > manager.current_scale * 2 or weapon.resource.scale < manager.current_scale * 0.5:
			#continue
		var weapon_scale = weapon.resource.scale
		# don't pick up shit weapons
		if weapon_scale <= current_weapon_resource.scale: continue

		var distance = transform.origin.distance_to(weapon.transform.origin)
		if distance < min_distance :
			min_distance = distance
			closest_weapon = weapon
		if weapon_scale < min_scale:
			min_scale = weapon_scale
			biggest_weapon = weapon
		eligible_weapons += 1
	
	if eligible_weapons > 0:
		# TODO: Show weapon pickup prompt
		pass
	if eligible_weapons > 1:
		picking_up_weapon = biggest_weapon
	else:
		if closest_weapon:
			picking_up_weapon = closest_weapon
			is_picking_up = true
			pickup_progress = pickup_increment
			camera.trauma += 0.09

func attack() :
	if not current_weapon_resource: return
	
	# Play the attack sound
	$AttackSound.play()

	var enemies = $AttackArea.get_overlapping_bodies()
	#print("Attack!")
	for enemy in enemies :
		if enemy.has_method("take_damage") :
			$CharacterCamera3D.trauma += 0.05
			enemy.take_damage(current_weapon_resource.damage)
			#print("Ouch")

func take_damage(damage):
	health -= damage
	print(health)
	if health < 0:
		print("DEATH")
		# TODO: Game over
		pass
