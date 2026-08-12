extends Label

@onready var day_timer: Timer = $"../CanvasLayer/dayTimer"

func _process(delta: float) -> void:
	# Display raw time left rounded to 1 decimal place
	text = str(int(day_timer.time_left))
