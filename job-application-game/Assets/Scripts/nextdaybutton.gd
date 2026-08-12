extends Button

signal nextday2

func _on_button_up() -> void:
	print("Next day button fired")
	nextday2.emit()
