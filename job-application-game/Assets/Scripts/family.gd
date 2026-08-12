extends Sprite2D

signal scene_changed
signal family_state_changed_signal(family_state)

@onready var enter_timer: Timer = %enterTimer
@onready var exit_timer: Timer = %exitTimer

@export var family_state := false


func _ready() -> void:
	hide()
	enter_timer.start()

func _on_enter_timer_timeout() -> void:
	exit_timer.start()
	family_state = true
	scene_changed.emit()
	family_state_changed_signal.emit(family_state)
	print("Family ON")


func _on_exit_timer_timeout() -> void:
	enter_timer.start()
	family_state = false
	scene_changed.emit()
	family_state_changed_signal.emit(family_state)
	print("Family OFF")

func _on_fade_fade_ready() -> void:
	visible = not visible
