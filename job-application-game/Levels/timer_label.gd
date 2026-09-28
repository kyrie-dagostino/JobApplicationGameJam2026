extends Control


@export var game_timer: Timer
@export var fade_in_duration: float = 0.5
@export var display_duration: float = 1.5

@onready var time_label: Label = $"."


var last_second := -1
var visible_until := 0.0


func _ready():

	modulate.a = 0.0
	time_label.text = ""


func _process(_delta):

	if game_timer == null:
		return

	var seconds_left: int = ceili(game_timer.time_left)

	if seconds_left != last_second:

		last_second = seconds_left

		if seconds_left == 60 \
		or seconds_left == 30 \
		or seconds_left == 10:

			show_warning(seconds_left)


	if visible_until > 0.0:

		if Time.get_ticks_msec() / 1000.0 >= visible_until:

			hide_warning()


func show_warning(seconds: int):

	# ONLY TimeLabel gets the number.
	time_label.text = str(seconds)

	visible_until = (
		Time.get_ticks_msec() / 1000.0
	) + display_duration

	var tween = create_tween()

	tween.tween_property(
		self,
		"modulate:a",
		1.0,
		fade_in_duration
	)


func hide_warning():

	visible_until = 0.0

	var tween = create_tween()

	tween.tween_property(
		self,
		"modulate:a",
		0.0,
		0.3
	)
