extends Control


# ============================================================
# SKILL CHECK SCENE
# ============================================================

signal skill_check_created(skill_check)
@export var playerdata: Resource
@onready var day_one: Node2D = $".."

const SKILL_CHECK = preload("res://UI/skill_check.tscn")


# ============================================================
# SETTINGS
# ============================================================

@export_category("Spawn Timing")

@export var min_delay: float = 1.0
@export var max_delay: float = 4.0
@export_category("Position")

@export var skill_check_position: Vector2 = Vector2(200, 200)

# ============================================================
# STATE
# ============================================================

var running: bool = false
var skill_check_active: bool = false


# ============================================================
# REFERENCES
# ============================================================

# Change this path if your UI CanvasLayer is somewhere else.

@onready var ui: CanvasLayer = $"../UI/VFX"

# ============================================================
# READY
# ============================================================

func _ready():
	await get_tree().create_timer(3).timeout #Grace period
	start_skill_check_loop()


# ============================================================
# MAIN QTE LOOP
# ============================================================

func start_skill_check_loop():

	if running:
		return

	running = true


	while running:

		# ----------------------------------------------------
		# Wait a random amount of time
		# ----------------------------------------------------

		var delay = randf_range(
			min_delay,
			max_delay
		)

		await get_tree().create_timer(delay).timeout


		# ----------------------------------------------------
		# Check whether spawning was stopped
		# ----------------------------------------------------

		if not running:
			return


		# ----------------------------------------------------
		# Safety check
		# ----------------------------------------------------

		if skill_check_active:
			continue


		# ----------------------------------------------------
		# Spawn skill check
		# ----------------------------------------------------

		var new_skill_check = SKILL_CHECK.instantiate()

		add_child(new_skill_check)

		new_skill_check.position = skill_check_position

		skill_check_active = true

		skill_check_created.emit(new_skill_check)

		# ----------------------------------------------------
		# Wait for the skill check to finish
		# ----------------------------------------------------

		var result = await new_skill_check.finished


		# ----------------------------------------------------
		# Handle result
		# ----------------------------------------------------

		handle_skill_check_result(result)


		# ----------------------------------------------------
		# Mark QTE as inactive
		# ----------------------------------------------------

		skill_check_active = false


# ============================================================
# HANDLE RESULT
# ============================================================

func handle_skill_check_result(result):

	match result:

		SkillCheck.Result.PERFECT:

			print("PERFECT SKILL CHECK!")

			# Strong flash
			ui.flash_screen(
				0.35,
				0.12
			)

			_on_perfect_skill_check()


		SkillCheck.Result.SUCCESS:

			print("SUCCESSFUL SKILL CHECK!")

			# Small flash
			ui.flash_screen(
				0.15,
				0.10
			)

			_on_success_skill_check()


		SkillCheck.Result.FAIL:

			print("FAILED SKILL CHECK!")

			# Stronger/slightly longer flash
			ui.flash_screen(
				0.30,
				0.20
			)

			_on_failed_skill_check()


# ============================================================
# RESULT FUNCTIONS
# ============================================================

func _on_perfect_skill_check():
	if day_one.family_state == false:
		playerdata.total_meat += 1
		playerdata.total_cash += 15
	if day_one.family_state == true:
		playerdata.tolerance -= 1


func _on_success_skill_check():
	if day_one.family_state == false:
		playerdata.total_meat += 1
		playerdata.total_cash += 10
	if day_one.family_state == true:
		playerdata.tolerance -= 1


func _on_failed_skill_check():
	pass


# ============================================================
# STOP SPAWNING
# ============================================================

func stop_spawning():

	running = false


# ============================================================
# START SPAWNING AGAIN
# ============================================================

func restart_spawning():

	if running:
		return

	start_skill_check_loop()
