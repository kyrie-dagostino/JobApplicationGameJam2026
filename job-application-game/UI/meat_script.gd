extends AnimatedSprite2D

@onready var meat_anim_player: AnimationPlayer = $AnimationPlayer
@onready var meat_timer: Timer = $MeatTimer

@export var meat_attack = false
@export var meat_attacked = false

func _on_qte_meat_anim_play() -> void:
	if meat_attack == false and meat_attacked == false:
		meat_anim_player.play("cutmeat")
		meat_attack = true

func _on_animation_player_animation_finished(anim_name: String) -> void:
	if anim_name == "cutmeat":
		meat_anim_player.play("nomeat")
		meat_attack = false
		meat_attacked = true

func _on_meat_timer_timeout() -> void:
	if meat_attack == false and meat_attacked == true:
		meat_anim_player.play("dropmeat")
		meat_attack = false
		meat_attacked = false
