extends CharacterBody3D


const SPEED = 5.0
const MOUSE_SENSITIVITY = 0.01

var target_velocity = Vector3.ZERO


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
		
	var movement_dir = transform.basis * Vector3(direction.x, 0, direction.z)
		
	if direction != Vector3.ZERO :
		direction = direction.normalized()
		
	velocity.x = movement_dir.x * SPEED
	velocity.z = movement_dir.z * SPEED
		
	#target_velocity.x = direction.x * SPEED
	#target_velocity.z = direction.z * SPEED
	
	#velocity = target_velocity
	
	move_and_slide()
	
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * MOUSE_SENSITIVITY)

	
