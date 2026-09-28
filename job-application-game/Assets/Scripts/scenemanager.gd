extends Node2D

signal scene_changed

@onready var enter_timer: Timer = $EnterTimer
@onready var exit_timer: Timer = $ExitTimer
@export var family_state: = false
@onready var ambient_1: AudioStreamPlayer2D = $Sound/Ambient1
@onready var ambient_2: AudioStreamPlayer2D = $Sound/Ambient2

@onready var home: AnimatedSprite2D = $Home
@onready var home_animation_tree: AnimationTree = $Home/AnimationTree
@onready var abattoir_animation_tree: AnimationTree = $Abattoir/AnimationTree

# Handle scene switching

func _ready() -> void:
	home.hide()
	enter_timer.start()
	ambient_1.play()

func _on_enter_timer_timeout() -> void:
	exit_timer.start()
	family_state = true
	home.show()
	ambient_2.play()
	ambient_1.stop()
	print("Family ON")


func _on_exit_timer_timeout() -> void:
	enter_timer.start()
	home.hide()
	family_state = false
	ambient_1.play()
	ambient_2.stop()
	print("Family OFF")
