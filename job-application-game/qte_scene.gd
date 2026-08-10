extends Control

@onready var timer: Timer = $Timer

const QTE = preload("uid://b52b8xk0x23aw")

var keyList = [
	{"keyString": "F", "keyCode": KEY_F},
	{"keyString": "H", "keyCode": KEY_H},
	{"keyString": "F", "keyCode": KEY_F},
	{"keyString": "H", "keyCode": KEY_H},
	{"keyString": "F", "keyCode": KEY_F},
	{"keyString": "F", "keyCode": KEY_F},
	{"keyString": "H", "keyCode": KEY_H},
	{"keyString": "H", "keyCode": KEY_H},
	{"keyString": "F", "keyCode": KEY_F},
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

	add_child(keyNode)
	count += 1

func _on_key_finished(keyGreat):
	keyPressedList.append(keyGreat)
