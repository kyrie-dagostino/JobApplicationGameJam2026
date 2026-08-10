extends CanvasLayer

signal fade_ready
signal day_fade_ready

@onready var black: ColorRect = $Fade/Black
@onready var animation_player: AnimationPlayer = $Fade/AnimationPlayer
@onready var fade_timer: Timer = $Fade/FadeTimer
@onready var day_fade_timer: Timer = $Fade/DayFadeTimer

func _on_family_sprite_scene_changed():
	animation_player.play("fade")
	fade_timer.start()

func _on_fade_timer_timeout():
	animation_player.play_backwards("fade")
	fade_ready.emit()

func _on_main_day_complete():
	animation_player.play("fade")
	day_fade_timer.start()

func _on_day_fade_timer_timeout():
	day_fade_ready.emit()
