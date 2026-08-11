extends Node2D

signal day_complete

var current_day : Node2D = null
var transition1 = preload("res://Levels/day1_transition.tscn")
var day2 = preload("res://Levels/day1.tscn")

func _ready() -> void:
	current_day = $day1

func _on_day_timer_timeout():
	print("Level complete")
	day_complete.emit()

func _on_canvas_layer_day_fade_ready() -> void:
	current_day.queue_free()
	var new_day = transition1.instantiate()
	add_child(new_day)

func _on_button_nextday1() -> void:
	print("Entering next day")
	current_day.queue_free()
	var new_day = day2.instantiate()
	add_child(new_day)
	
