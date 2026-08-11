extends AnimatedSprite2D

@onready var state_mach: AnimationTree = $AnimationTree
@onready var playback = $AnimationTree.get("parameters/playback")
const QTE = preload("res://UI/qte.tscn")

func _on_qte_scene_meat_emit() -> void:
	playback.start("cutmeat")
	print("Successful anim")
