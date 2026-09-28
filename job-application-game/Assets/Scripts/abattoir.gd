extends AnimatedSprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = $AnimationTree.get("parameters/playback")

@onready var skill_check_spawner = $"../SkillCheckSpawner"

var family_state = false


func _ready() -> void:

	skill_check_spawner.skill_check_created.connect(
		_on_skill_check_created
	)
	animation_tree.active = true
	playback.start("meatstart")


func _on_skill_check_created(new_skill_check):

	new_skill_check.skill_check_started.connect(
		_on_skill_check_started
	)

	new_skill_check.skill_check_perfect.connect(
		_on_skill_check_perfect
	)

	new_skill_check.skill_check_success.connect(
		_on_skill_check_success
	)

	new_skill_check.skill_check_failed.connect(
		_on_skill_check_failed
	)

func _on_skill_check_started():
	if family_state == false:
		print("Skill check started")


func _on_skill_check_perfect():
	if family_state == false:
		print("Skill check PERFECT")
		playback.start("cutmeat")


func _on_skill_check_success():
	if family_state == false:
		print("Skill check SUCCESS")
		playback.start("cutmeat")


func _on_skill_check_failed():
	if family_state == false:
		print("Skill check FAILED")

func _on_enter_timer_timeout() -> void:
	family_state = true
	animation_tree.active = false

func _on_exit_timer_timeout() -> void:
	family_state = false
	animation_tree.active = true
