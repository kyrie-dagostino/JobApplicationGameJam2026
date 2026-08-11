extends Control

signal finished(succsess)

@export var keyString: String = "Q"
@export var keyCode: Key = KEY_Q
@export var eventDuration := 2.0
@export var displayDuration:= 0.5
@export var meat_signal: Signal

@onready var color_rect: ColorRect = %ColorRect
@onready var key_label: Label = %KeyLabel
@onready var succsess_label: Label = %SuccsessLabel
@onready var swing_sound: AudioStreamPlayer2D = $AudioStreamPlayer2D



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
	if Input.is_key_pressed(keyCode) and not succsess_label.visible:
		succsess_label.show()
		swing_sound.play()
		tween.kill()
		succsess = true
		print("Meat hit")
		meat_signal.emit()
		await get_tree().create_timer(displayDuration).timeout
		
		hide()
