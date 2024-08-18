extends Label

var stuff_to_pick_up = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if stuff_to_pick_up:
		text = "There's stuff to pick up"
