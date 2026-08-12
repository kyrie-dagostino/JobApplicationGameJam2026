extends Control

signal finished(succsess)

@export var keyString: String = "Q"
@export var keyCode: Key = KEY_Q
@export var eventDuration := 0.5
@export var displayDuration:= 0.2
@export var meat_signal: Signal
@export var trauma_signal: Signal
@export var did_family_state_change = false
@export var cash: Resource

@onready var cooldown_timer: Timer = $CooldownTimer

@onready var color_rect: ColorRect = %ColorRect
@onready var key_label: Label = %KeyLabel
@onready var succsess_label: Label = %SuccsessLabel
@onready var child_label: Label = %ChildLabel
@onready var trauma_vignette: Control = $ColorRect/TraumaVignette
@onready var trauma_vignette_player: AnimationPlayer = $ColorRect/TraumaVignette/TraumaVignettePlayer
@onready var trauma_timer: Timer = $ColorRect/TraumaVignette/TraumaTimer
@onready var trauma_audio: AudioStreamPlayer2D = $TraumaAudio




# QTE functionality

var tween = create_tween()
var succsess = false

func _ready() -> void:
	add_to_group("QTE")
	key_label.text = keyString
	print("spawnsucces")
	await _animation()
	
	if not succsess:
		hide()
		
func _animation():
	tween.tween_property(color_rect, "material:shader_parameter/value", 0, eventDuration)
	
	await tween.finished

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(keyCode) and not succsess_label.visible and not child_label.visible:
		tween.kill()
		succsess = true
		print("QTE hit")
		award_cash()
		trauma_inflicted()
		cooldown_timer.start()
		await get_tree().create_timer(displayDuration).timeout
		
		hide()
# Signal

func determine_family_state(new_family_state: bool) -> void:
	did_family_state_change = new_family_state
	print("QTE family state:", did_family_state_change)

# Cash

func award_cash() -> void:
	print("Cash check:", did_family_state_change)

	if not did_family_state_change:
		succsess_label.show()
		cash.cash += 10
		cash.meat_obtained += 1
		meat_signal.emit()
		print("Awarded 10 cash, per 1 meat!")

# Hits

func trauma_inflicted() -> void:
	print("Trauma check:", did_family_state_change)

	if did_family_state_change:
		child_label.show()
		print("TRAUMA SHOULD PLAY")
		trauma_vignette_player.play("trauma")
		trauma_audio.play()
		trauma_signal.emit()
		trauma_timer.start()

func _on_trauma_timer_timeout():
	trauma_vignette_player.play_backwards("trauma")
