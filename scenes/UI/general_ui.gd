extends Control

var pause_menu = preload("res://scenes/UI/Menus/pause_menu.tscn")
var is_paused = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("open_pause_menu") and is_paused == false:
		var instance = pause_menu.instantiate()
		add_child(instance)
		get_tree().paused = true
