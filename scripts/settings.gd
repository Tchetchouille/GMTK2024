extends Control

var settings_menu = preload("res://scenes/UI/settings_menu.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_settings_button_pressed() -> void:	
	print("test")
	var instance = settings_menu.instantiate()
	$"../../..".add_child(instance)
