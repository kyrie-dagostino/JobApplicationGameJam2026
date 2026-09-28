class_name SkillCheck
extends Control

signal finished(result)

signal skill_check_started
signal skill_check_perfect
signal skill_check_success
signal skill_check_failed

enum Result {
	FAIL,
	SUCCESS,
	PERFECT
}


# ============================================================
# BAR SETTINGS
# ============================================================

@export_category("Bar")

@export var bar_width: float = 450.0
@export var bar_height: float = 32.0
@export var bar_position: Vector2 = Vector2(25, 45)

@export var pixel_size: float = 4.0


# ============================================================
# ZONES
# ============================================================

@export_category("Zones")

@export var success_width: float = 120.0
@export var perfect_width: float = 35.0


# ============================================================
# CURSOR
# ============================================================

@export_category("Cursor")

@export var cursor_width: float = 4.0
@export var cursor_height: float = 46.0

@export var cursor_speed_min: float = 250.0
@export var cursor_speed_max: float = 400.0


# ============================================================
# TIMING
# ============================================================

@export_category("Timing")

@export var time_limit: float = 5.0


# ============================================================
# COLORS
# ============================================================

@export_category("Colors")

@export var background_color := Color("#111318")
@export var bar_color := Color("#252932")
@export var bar_dark_color := Color("#17191e")

@export var success_color := Color("#4d8f5b")
@export var success_dark_color := Color("#376641")

@export var perfect_color := Color("#f2c94c")
@export var perfect_bright_color := Color("#fff0a3")

@export var cursor_color := Color("#f2f2f2")
@export var cursor_shadow_color := Color("#000000")

@export var border_color := Color("#d0d0d0")

@export var text_color := Color("#eeeeee")

@export var fail_color := Color("#d94b4b")


# ============================================================
# VARIABLES
# ============================================================

var cursor_position := 0.0
var cursor_direction := 1.0
var cursor_speed := 300.0

var success_start := 0.0
var success_end := 0.0

var perfect_start := 0.0
var perfect_end := 0.0

var time_remaining := 0.0

var finished_already := false

# Visual feedback
var feedback_text := ""
var feedback_timer := 0.0
var perfect_pulse := 0.0


# ============================================================
# READY
# ============================================================

func _ready():

	randomize_skill_check()

	time_remaining = time_limit

	cursor_position = 0.0
	cursor_direction = 1.0

	queue_redraw()

	skill_check_started.emit()

# ============================================================
# PROCESS
# ============================================================

func _process(delta):

	if finished_already:
		# Still allow the feedback animation to play.
		update_visual_effects(delta)
		queue_redraw()
		return


	# --------------------------------------------------------
	# Move cursor
	# --------------------------------------------------------

	cursor_position += cursor_speed * cursor_direction * delta


	if cursor_position >= bar_width:

		cursor_position = bar_width
		cursor_direction = -1.0


	elif cursor_position <= 0.0:

		cursor_position = 0.0
		cursor_direction = 1.0


	# --------------------------------------------------------
	# Timer
	# --------------------------------------------------------

	time_remaining -= delta

	if time_remaining <= 0.0:

		fail()

		return


	update_visual_effects(delta)

	queue_redraw()


# ============================================================
# VISUAL EFFECTS
# ============================================================

func update_visual_effects(delta):

	feedback_timer -= delta

	# Pulse the perfect zone.
	perfect_pulse += delta * 5.0


# ============================================================
# RANDOMIZE
# ============================================================

func randomize_skill_check():

	cursor_speed = randf_range(
		cursor_speed_min,
		cursor_speed_max
	)


	# --------------------------------------------------------
	# Success zone
	# --------------------------------------------------------

	var max_success_start = bar_width - success_width

	success_start = randf_range(
		0.0,
		max_success_start
	)

	success_end = success_start + success_width


	# --------------------------------------------------------
	# Perfect zone
	# --------------------------------------------------------

	var max_perfect_start = success_end - perfect_width

	perfect_start = randf_range(
		success_start,
		max_perfect_start
	)

	perfect_end = perfect_start + perfect_width


# ============================================================
# INPUT
# ============================================================

func _input(event):

	if finished_already:
		return

	if event.is_action_pressed("skill_check"):

		check_result()


# ============================================================
# CHECK RESULT
# ============================================================

func check_result():

	if finished_already:
		return


	if cursor_position >= perfect_start \
	and cursor_position <= perfect_end:

		perfect()

		return


	if cursor_position >= success_start \
	and cursor_position <= success_end:

		success()

		return


	fail()


# ============================================================
# PERFECT
# ============================================================

func perfect():

	if finished_already:
		return

	finished_already = true

	feedback_text = "PERFECT!"

	feedback_timer = 0.6

	print("PERFECT!")

	skill_check_perfect.emit()

	finished.emit(Result.PERFECT)

	# Delay freeing so the feedback can actually be seen.
	await get_tree().create_timer(0.6).timeout

	queue_free()


# ============================================================
# SUCCESS
# ============================================================

func success():

	if finished_already:
		return

	finished_already = true

	feedback_text = "SUCCESS"

	feedback_timer = 0.5

	print("SUCCESS!")

	skill_check_success.emit()

	finished.emit(Result.SUCCESS)

	await get_tree().create_timer(0.5).timeout

	queue_free()


# ============================================================
# FAIL
# ============================================================

func fail():

	if finished_already:
		return

	finished_already = true

	feedback_text = "MISS"

	feedback_timer = 0.6

	print("FAIL!")

	skill_check_failed.emit()

	finished.emit(Result.FAIL)

	await get_tree().create_timer(0.6).timeout

	queue_free()


# ============================================================
# DRAW EVERYTHING
# ============================================================

func _draw():

	var x = bar_position.x
	var y = bar_position.y


	# ========================================================
	# OUTER PANEL
	# ========================================================

	var panel_rect = Rect2(
		x - 18,
		y - 28,
		bar_width + 36,
		bar_height + 56
	)

	draw_rect(
		panel_rect,
		background_color
	)


	# Pixel-style panel corners
	draw_rect(
		Rect2(x - 14, y - 28, 10, 4),
		border_color
	)

	draw_rect(
		Rect2(x + bar_width + 4, y - 28, 10, 4),
		border_color
	)

	draw_rect(
		Rect2(x - 14, y + bar_height + 24, 10, 4),
		border_color
	)

	draw_rect(
		Rect2(x + bar_width + 4, y + bar_height + 24, 10, 4),
		border_color
	)


	# ========================================================
	# BAR SHADOW
	# ========================================================

	var shadow_rect = Rect2(
		x + 4,
		y + 4,
		bar_width,
		bar_height
	)

	draw_rect(
		shadow_rect,
		Color("#050608")
	)


	# ========================================================
	# BAR BACKGROUND
	# ========================================================

	var bar_rect = Rect2(
		x,
		y,
		bar_width,
		bar_height
	)

	draw_rect(
		bar_rect,
		bar_dark_color
	)


	# ========================================================
	# SUCCESS ZONE
	# ========================================================

	var success_rect = Rect2(
		x + success_start,
		y,
		success_width,
		bar_height
	)

	draw_rect(
		success_rect,
		success_color
	)


	# --------------------------------------------------------
	# Success zone stripes
	# --------------------------------------------------------

	var stripe_x = success_start

	while stripe_x < success_end:

		draw_rect(
			Rect2(
				x + stripe_x,
				y,
				3,
				bar_height
			),
			success_dark_color
		)

		stripe_x += 12


	# ========================================================
	# PERFECT ZONE
	# ========================================================

	var pulse = (sin(perfect_pulse) + 1.0) * 0.5

	var perfect_color_current = perfect_color.lerp(
		perfect_bright_color,
		pulse * 0.35
	)

	var perfect_rect = Rect2(
		x + perfect_start,
		y,
		perfect_width,
		bar_height
	)

	draw_rect(
		perfect_rect,
		perfect_color_current
	)


	# ========================================================
	# PERFECT ZONE INNER LINE
	# ========================================================

	draw_rect(
		Rect2(
			x + perfect_start + 4,
			y + 4,
			3,
			bar_height - 8
		),
		perfect_bright_color
	)

	draw_rect(
		Rect2(
			x + perfect_end - 7,
			y + 4,
			3,
			bar_height - 8
		),
		perfect_bright_color
	)


	# ========================================================
	# PIXEL SEGMENTS
	# ========================================================

	var segment_width := 8.0
	var segment_gap := 2.0

	var segment_x := 0.0

	while segment_x < bar_width:

		var segment_rect = Rect2(
			x + segment_x,
			y,
			segment_width,
			3
		)

		draw_rect(
			segment_rect,
			Color("#ffffff", 0.08)
		)

		segment_x += segment_width + segment_gap


	# ========================================================
	# BAR BORDER
	# ========================================================

	draw_rect(
		bar_rect,
		border_color,
		false,
		2.0
	)


	# ========================================================
	# CURSOR SHADOW
	# ========================================================

	var cursor_x = x + cursor_position

	draw_rect(
		Rect2(
			cursor_x - cursor_width / 2.0 + 3,
			y - 5,
			cursor_width,
			cursor_height
		),
		cursor_shadow_color
	)


	# ========================================================
	# CURSOR
	# ========================================================

	draw_rect(
		Rect2(
			cursor_x - cursor_width / 2.0,
			y - 7,
			cursor_width,
			cursor_height
		),
		cursor_color
	)


	# ========================================================
	# CURSOR TOP ARROW
	# ========================================================

	var arrow_points = PackedVector2Array([
		Vector2(cursor_x - 7, y - 8),
		Vector2(cursor_x + 7, y - 8),
		Vector2(cursor_x, y - 15)
	])

	draw_colored_polygon(
		arrow_points,
		cursor_color
	)


	# ========================================================
	# "PRESS!" INDICATOR
	# ========================================================

	if not finished_already:

		var indicator_x = cursor_x

		draw_string(
			ThemeDB.fallback_font,
			Vector2(
				indicator_x - 18,
				y - 22
			),
			"PRESS!",
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			10,
			text_color
		)


	# ========================================================
	# FEEDBACK
	# ========================================================

	if feedback_timer > 0.0:

		var feedback_color = text_color

		if feedback_text == "PERFECT!":
			feedback_color = perfect_bright_color

		elif feedback_text == "SUCCESS":
			feedback_color = success_color

		elif feedback_text == "MISS":
			feedback_color = fail_color


		draw_string(
			ThemeDB.fallback_font,
			Vector2(
				x + bar_width / 2.0 - 35,
				y + bar_height + 25
			),
			feedback_text,
			HORIZONTAL_ALIGNMENT_LEFT,
			-1,
			14,
			feedback_color
		)
