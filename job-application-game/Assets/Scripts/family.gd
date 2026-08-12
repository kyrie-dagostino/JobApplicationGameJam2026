extends AnimatedSprite2D

signal scene_changed
signal family_state_changed_signal(family_state)

@onready var enter_timer: Timer = %enterTimer
@onready var exit_timer: Timer = %exitTimer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var playback = $AnimationTree.get("parameters/playback")

@export var family_state := false


func _ready() -> void:
	hide()
	enter_timer.start()

func _on_enter_timer_timeout() -> void:
	exit_timer.start()
	show()
	family_state = true
	scene_changed.emit()
	family_state_changed_signal.emit(family_state)
	print("Family ON")


func _on_exit_timer_timeout() -> void:
	enter_timer.start()
	hide()
	family_state = false
	scene_changed.emit()
	family_state_changed_signal.emit(family_state)
	print("Family OFF")

func _on_fade_fade_ready() -> void:
	visible = not visible

func _on_qte_scene_trauma_emit() -> void:
	playback.start("child_trauma")
	print("Successful trauma")

func _on_family_sprite_scene_changed() -> void:
	if family_state == false:
		animation_tree.active = !animation_tree.active
