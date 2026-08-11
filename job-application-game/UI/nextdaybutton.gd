extends Button

signal nextday1

func _on_button_up() -> void:
	nextday1.emit()
