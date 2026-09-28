extends Label

@onready var vfx: VFX = $".."
@onready var next_day_button: Button = $"../NextDayButton"
@onready var day_text: Label = $"../DayText"

func _ready() -> void:
	hide()
	next_day_button.hide()

func _on_day_timer_timeout() -> void:
	get_tree().paused = true
	vfx.end_fade_screen()

func _on_vfx_fade_done() -> void:
	show()
	await get_tree().create_timer(2).timeout
	next_day_button.show()


func _on_next_day_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Levels/intermission1.tscn")
