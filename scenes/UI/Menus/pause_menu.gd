extends Control

func _on_resume_button_pressed() -> void:
	print("test")
	get_tree().paused = false
	queue_free()
