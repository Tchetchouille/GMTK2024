extends Camera3D

@export var intensity = 0.1
@export var decay = 0.005
@export var max_trauma = 1

var trauma: float
var initial_transform: Transform3D

func _ready() -> void:
	initial_transform = self.transform
	
func _process(float) -> void:
	if trauma <= 0:
		initial_transform = self.transform 
	else:
		var offset = Vector3(
			randf_range(-trauma, trauma),
			randf_range(-trauma, trauma),
			randf_range(-trauma, trauma)
		)
		trauma -= decay

		self.transform.origin = initial_transform.origin + offset

	#if Input.is_action_just_pressed("click_action") and (trauma + intensity) < max_trauma:
			#trauma += intensity
			#print(trauma)
