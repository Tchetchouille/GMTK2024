extends Control

func _ready() -> void:
	$SettingsMenu.hide()

func _on_resume_button_pressed() -> void:
	get_tree().paused = false
	queue_free()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_pause_menu") and get_tree().paused == true:
		get_tree().paused = false
		queue_free()
