extends Control

var settings_menu = preload("res://scenes/UI/Menus/settings_menu.tscn")

func _on_settings_button_pressed() -> void:	
	var instance = settings_menu.instantiate()
	$"../../..".add_child(instance)
