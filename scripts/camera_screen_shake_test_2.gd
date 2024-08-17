extends Camera3D

var shaking = true;
@export var magnitude = 0.1

func _process(delta: float) -> void:
	if shaking == true:
		shake()
		
func shake():
	print("test")
