extends MarginContainer

var character = preload("res://scenes/Character.tscn")

func _on_sensitivity_slider_value_changed(value: float) -> void:
	print(character)
