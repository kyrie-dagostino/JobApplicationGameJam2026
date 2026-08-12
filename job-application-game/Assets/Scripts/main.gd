extends Node2D

signal day_complete

var current_day: Node2D = null

var day1 = preload("res://Levels/day1.tscn")
var transition1 = preload("res://Levels/day1_transition.tscn")
var day2 = preload("res://Levels/day2.tscn")
var transition2 = preload("res://Levels/day2_transition.tscn")
var day3 = preload("res://Levels/day3.tscn")
var transition3 = preload("res://Levels/day3_transition.tscn")

var eviction = preload("res://Levels/eviction_ending.tscn")


@export var cash: Resource
@export var days: Resource

@onready var day_timer: Timer = $CanvasLayer/dayTimer
@onready var timer_label: Label = $TimerLabel

func _ready() -> void:
	current_day = $main_menu
	day_timer.stop()

# Quit funct

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()

func on_max_meat() -> void:
	if cash.meat_obtained >= 20:
		print("Level complete")
		day_complete.emit()

# Game start
func _on_main_menu_start_game() -> void:
	print("Entering next day")

	current_day.queue_free()
	var new_day = day1.instantiate()
	add_child(new_day)

	new_day.position = Vector2.ZERO
	current_day = new_day

	timer_label.show()
	day_timer.start()

	print("Day 1 loaded")

func _on_day_timer_timeout() -> void:
	print("Level complete")
	day_complete.emit()

# Endings

func eviction_ending():
	if cash.cash < 0 and days.days_left == 0:
		if is_instance_valid(current_day):
			current_day.queue_free()

	day_timer.stop()
	timer_label.hide()

	var transition = eviction.instantiate()
	add_child(transition)


func _on_canvas_layer_day_fade_ready() -> void:
	if days.days_left > 0:
		days.days_left -= 1

	if is_instance_valid(current_day):
		current_day.queue_free()

	day_timer.stop()
	timer_label.hide()

	var transition = transition1.instantiate()
	add_child(transition)

	var button = transition.get_node(
		"CanvasLayer/ShopScene/ColorRect/Button"
	)

	button.nextday2.connect(
		_on_button_nextday2.bind(transition)
	)

func _on_button_nextday2(transition) -> void:
	print("Entering next day")

	if is_instance_valid(transition):
		transition.queue_free()

	var new_day = day2.instantiate()
	add_child(new_day)

	new_day.position = Vector2.ZERO
	current_day = new_day

	timer_label.show()
	day_timer.start()

	print("Day 2 loaded")
