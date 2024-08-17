extends CharacterBody3D

@export var speed = 10.0
@export var inactivity_pickup_loss: float = 10
@export var scale_increment: float = 0.01
@export var current_weapon_resource: WeaponResource

@onready var mouse_sensitivity = 0.01#get_var("look-sensitivity")

var target_velocity = Vector3.ZERO
var weapons_in_range = []
var is_picking_up = false
var pickup_progress: float = 0
var picking_up_weapon = null
var scale_: float = 0.12

func _physics_process(delta):
	var direction = Vector3.ZERO
	
	if is_picking_up:
		if Input.is_action_just_pressed("click_action") :
			pickup_progress += 10

			if pickup_progress > 100:
				current_weapon_resource = picking_up_weapon.pick_up()
				pickup_progress = 0
				picking_up_weapon = null
				is_picking_up = false
				print("Weapon picked up!")
		else:
			# loose progress if not clicking
			pickup_progress -= inactivity_pickup_loss * delta

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
	
	move_and_slide()
	

	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)

func _on_collision_area_body_entered(body):
	print("Entered")
	var weapon = body.get_parent().get_parent()
	if weapon is Weapon :
		print("Entered weapon")
		weapons_in_range.append(weapon)

func _on_collision_area_body_exited(body):
	print("Exited")
	var weapon = body.get_parent().get_parent()
	if weapon is Weapon :
		print("Exited weapon")
		weapons_in_range.erase(weapon)

func pickup_weapon() :
	var min_distance = INF
	var closest_weapon = null
	for weapon in weapons_in_range:
		var distance = transform.origin.distance_to(weapon.transform.origin)
		if distance < min_distance :
			min_distance = distance
			closest_weapon = weapon
	
	if closest_weapon:
		picking_up_weapon = closest_weapon
		is_picking_up = true

func attack() :
	if not current_weapon_resource: return

	var enemies = $AttackArea.get_overlapping_bodies()
	print("Attack!")
	for enemy in enemies :
		if enemy.has_method("take_damage") :
			enemy.take_damage(current_weapon_resource.scale)
			print("Ouch") 

func get_fat():
	scale_ += scale_increment;
	#scale.x = scale_
	#scale.y = scale_
	#scale.z = scale_
