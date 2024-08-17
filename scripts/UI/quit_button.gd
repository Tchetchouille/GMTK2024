extends Control

# Quitting game when quit button is pressed.
func _on_button_pressed() -> void:
	get_tree().quit()
