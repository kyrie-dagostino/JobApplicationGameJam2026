extends CanvasLayer

signal fade_ready

@onready var black: ColorRect = $Fade/Black
@onready var animation_player: AnimationPlayer = $Fade/AnimationPlayer
@onready var fade_timer: Timer = $Fade/FadeTimer

func _on_family_sprite_scene_changed():
	animation_player.play("fade")
	fade_timer.start()

func _on_fade_timer_timeout():
	animation_player.play_backwards("fade")
	fade_ready.emit()
