class_name VFX
extends CanvasLayer

signal fade_done

@onready var qte_flash: ColorRect = $SkillFlash
@onready var end_fade: ColorRect = $EndFade

var qte_flash_tween: Tween
var end_fade_tween: Tween

func _ready():

	qte_flash.color.a = 0.0
	end_fade.color.a = 0.0


func flash_screen(strength: float = 0.2, duration: float = 0.15):
	if qte_flash_tween != null and qte_flash_tween.is_valid():
		qte_flash_tween.kill()
	qte_flash.color.a = strength
	qte_flash_tween = create_tween()
	qte_flash_tween.tween_property(
		qte_flash,
		"color:a",
		0.0,
		duration
	)

func end_fade_screen(strength: float = 0.2, duration: float = 2.00):
	end_fade.color.a = strength
	end_fade_tween = create_tween()
	end_fade_tween.tween_property(
		end_fade,
		"color:a",
		5.0,
		duration
	)
	await get_tree().create_timer(2).timeout
	fade_done.emit()
