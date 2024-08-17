extends Control

var pause_menu = preload("res://scenes/UI/Menus/pause_menu.tscn")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_pause_menu") and get_tree().paused == false:
		var instance = pause_menu.instantiate()
		add_child(instance)
		get_tree().paused = true
