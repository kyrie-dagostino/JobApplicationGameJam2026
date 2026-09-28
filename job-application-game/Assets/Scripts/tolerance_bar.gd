extends ProgressBar

@export var playerdata: Resource
@onready var skill_check_spawner: Control = $"../../SkillCheckSpawner"

func _ready() -> void:
	max_value = playerdata.max_tolerance
	set_health_bar()

func set_health_bar() -> void:
	value = playerdata.tolerance

func _process(_delta: float) -> void:
	set_health_bar()
