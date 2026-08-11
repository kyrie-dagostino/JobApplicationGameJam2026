extends Control

signal meat_emit

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
	
	var keyNode = QTE.instantiate()
	keyNode.finished.connect(_on_key_finished)
	keyNode.keyCode = keyList[count].keyCode
	keyNode.keyString = keyList[count].keyString
	keyNode.meat_signal = meat_emit
	add_child(keyNode)
	count += 1
func _meat_cut_doit():
		meat_emit.emit()
		print("Hello World Whatever")

func _on_key_finished(keySuccsess):
	keyPressedList.append(keySuccsess)
