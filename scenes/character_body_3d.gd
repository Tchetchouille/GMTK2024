extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5


func _physics_process(delta):
	
	var direction = Vector3.ZERO
	
	if Input.is_action_pressed("move_forward") :
		direction.z -= 1
	if Input.is_action_pressed("move_backwards") :
		direction.z += 1
	if Input.is_action_pressed("move_right") :
		direction.x += 1
	if Input.is_action_pressed("move_left") :
		direction.x -= 1
		
	if direction != Vector3.ZERO :
		direction = direction.normalized()
		$Character.basis = 
	
