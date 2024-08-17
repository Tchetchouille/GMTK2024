extends MarginContainer

func _on_sensitivity_slider_value_changed(value: float) -> void:
	SaveSystem.set_var("look_sensitivity", value * 0.01)
