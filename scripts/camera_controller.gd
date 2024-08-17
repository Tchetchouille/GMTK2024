extends Node3D

@export var offset = 5;

# Shamelessly stolen from: https://www.youtube.com/watch?v=yVde3I3K7oo
func _process(delta: float) -> void:
	var new_pos = Vector3($"..".position.x, position.y, $"..".position.z)
	if position.distance_to(new_pos) >= offset:
		position = lerp(position, new_pos, 0.01)
	look_at($"..".position)
