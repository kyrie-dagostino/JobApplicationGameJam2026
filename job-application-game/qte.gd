extends Control

@export var keyString: String = "F"
@export var keyCode: Key = KEY_F
@export var eventDuration:= 0.5
@export var displayDuration:= 0.5

@onready var color_rect: ColorRect = $ColorRect
@onready var label_key: Label = $ColorRect/Label_Key
@onready var label_great: Label = $ColorRect/Label_Great

var tween = create_tween()
var great = false

func _ready() -> void:
	add_to_group("QTE")
	label_key.text = keyString
	
	await _animation()
	
	if not great:
		hide()

func _animation():
	tween.tween_property(color_rect, "material:shader_parameter/value", 0, eventDuration)
	
	await tween.finished

func _input(event: InputEvent) -> void:
	if Input.is_key_pressed(keyCode) and not label_great.visible:
		label_great.show()
		tween.kill()
		great = true
		
		await get_tree().create_timer(displayDuration).timeout
		
		hide()
