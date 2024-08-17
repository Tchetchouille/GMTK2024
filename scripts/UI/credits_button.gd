extends Control

@onready var credits_menu = $"../../../CreditsMenu"

# Opening Credits when setting button is pressed.	
func _on_button_pressed() -> void:
	credits_menu.show()
