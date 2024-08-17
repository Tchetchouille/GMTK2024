extends Control

func _ready() -> void:
	$SettingsMenu.hide()
	$CreditsMenu.hide()

# Loading the main scene when play button is pressed.
func _on_play_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")
