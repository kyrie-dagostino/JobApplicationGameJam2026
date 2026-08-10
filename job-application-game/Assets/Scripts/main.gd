extends Node2D

signal day_complete

var current_day : Node2D = null
var next_day = preload("res://day1_transition.tscn")

func _ready() -> void:
	current_day = $day1

func _on_day_timer_timeout():
	print("Level complete")
	day_complete.emit()

func _on_canvas_layer_day_fade_ready() -> void:
	current_day.queue_free()
	var new_day = next_day.instantiate()
	add_child(new_day)
