extends Node2D

signal start_game()

func _on_play_button_button_up() -> void:
	start_game.emit()


func _on_quit_button_button_up() -> void:
	get_tree().quit()
