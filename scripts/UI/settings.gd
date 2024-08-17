extends Control

@onready var settings_menu = $"../../../SettingsMenu"

func _on_settings_button_pressed() -> void:	
	settings_menu.show()
