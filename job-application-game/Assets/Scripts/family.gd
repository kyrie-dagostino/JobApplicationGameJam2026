extends Sprite2D

signal scene_changed

@onready var enter_timer: Timer = %enterTimer
@onready var exit_timer: Timer = %exitTimer
@export var family_state = false

func _ready() -> void:
	hide()
	enter_timer.start()

func _on_enter_timer_timeout():
	exit_timer.start()
	scene_changed.emit()
	family_state = true

func _on_exit_timer_timeout():
	enter_timer.start()
	scene_changed.emit()
	family_state = false

func _on_fade_fade_ready() -> void:
	visible = not visible
