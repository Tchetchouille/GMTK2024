extends Control

var credits_menu = preload("res://scenes/UI/Menus/credits_menu.tscn")

# Opening Credits when setting button is pressed.	
func _on_button_pressed() -> void:
	var instance = credits_menu.instantiate()
	$"../../..".add_child(instance)
