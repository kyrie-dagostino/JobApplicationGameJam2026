extends Control

@onready var family_sprite: AnimatedSprite2D = %familySprite

@export var tol: Resource

func _ready() -> void:
	set_health_label()
	$HealthBar.max_value = tol.MAX_HEALTH
	set_health_bar()

func set_health_label() -> void:
	$HealthLabel.text = "Tolerance"

func set_health_bar() -> void:
	$HealthBar.value = tol.health

func _on_qte_scene_trauma_emit() -> void:
	if family_sprite.family_state == true:
		damage()

func damage() -> void:
	tol.health -= 1
	print("Took T damage!")
	if tol.health < 0:
		tol.health = 0
	set_health_label()
	set_health_bar()
