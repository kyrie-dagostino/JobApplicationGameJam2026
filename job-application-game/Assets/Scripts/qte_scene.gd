extends Control

signal meat_emit
signal trauma_emit

@onready var family_sprite: Sprite2D = %familySprite
@onready var timer: Timer = $Timer

const QTE = preload("res://UI/qte.tscn")

var keyList = [
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "E", "keyCode": KEY_E},
	{"keyString": "E", "keyCode": KEY_E},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "E", "keyCode": KEY_E},
	{"keyString": "E", "keyCode": KEY_E},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "E", "keyCode": KEY_E},
	{"keyString": "E", "keyCode": KEY_E},
	{"keyString": "E", "keyCode": KEY_E},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "E", "keyCode": KEY_E},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "E", "keyCode": KEY_E},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "E", "keyCode": KEY_E},
	{"keyString": "Q", "keyCode": KEY_Q},
	{"keyString": "E", "keyCode": KEY_E},
]

var count = 0
var keyPressedList = []


func _on_timer_timeout() -> void:
	if count == keyList.size():
		timer.stop()
		return
	meat_play()


func meat_play() -> void:
	var keyNode = QTE.instantiate()
	keyNode.finished.connect(_on_key_finished)
	keyNode.keyCode = keyList[count].keyCode
	keyNode.keyString = keyList[count].keyString
	keyNode.meat_signal = meat_emit
	keyNode.trauma_signal = trauma_emit
	add_child(keyNode)
	keyNode.determine_family_state(family_sprite.family_state)
	family_sprite.family_state_changed_signal.connect(
		keyNode.determine_family_state
	)
	count += 1


func _on_key_finished(keySuccsess) -> void:
	keyPressedList.append(keySuccsess)
