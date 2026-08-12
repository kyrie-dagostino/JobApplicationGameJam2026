extends AnimatedSprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = $AnimationTree.get("parameters/playback")

const QTE = preload("res://UI/qte.tscn")

func _ready() -> void:
	animation_tree.active = true
	playback.start("daymeat")

func _on_qte_scene_meat_emit() -> void:
	playback.start("cutmeat")
	print("Successful anim")


func _on_family_sprite_scene_changed() -> void:
	animation_tree.active = !animation_tree.active
