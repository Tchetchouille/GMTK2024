extends CharacterBody3D

@export var speed = 10.0
@export var mouse_sensitivity = 0.01
@export var current_weapon_resource : WeaponResource

var target_velocity = Vector3.ZERO
var weapons_in_range = []

func _physics_process(delta):
	
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward") :
		direction.z -= 1
	if Input.is_action_pressed("move_back") :
		direction.z += 1
	if Input.is_action_pressed("move_right") :
		direction.x += 1
	if Input.is_action_pressed("move_left") :
		direction.x -= 1
		
	if Input.is_action_just_pressed("click_action") :
		pickup_weapon()
		
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
	if body.get_parent() is Weapon :
		print("Entered weapon")
		weapons_in_range.append(body.get_parent())

func _on_collision_area_body_exited(body):
	print("Exited")
	if body.get_parent() is Weapon :
		print("Exited weapon")
		weapons_in_range.erase(body.get_parent())

func pickup_weapon() :
	var min = INF
	var closest_weapon = null
	
	#Pick closest weapon 
	for weapon in weapons_in_range:
		var distance = transform.origin.distance_to(weapon.transform.origin)
		if distance < min :
			min = distance
			closest_weapon = weapon
	current_weapon_resource = closest_weapon.pick_up()
	

	
	
	
