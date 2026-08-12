extends Control

signal next_day_clicked

@export var cash: Resource
@export var tol: Resource
@export var days: Resource

@onready var dues: Label = $JournalRect/Dues
@onready var made: Label = $JournalRect/Made
@onready var total: Label = $JournalRect/Total
@onready var kisses: Label = $JournalRect/Kisses

func _ready():
	label_calcs()
	show_kisses()

func label_calcs():
	dues.text = "due in %s days" % days.days_left
	made.text = "%s$" % cash.cash
	total.text = "%s$" % (cash.cash - 100)
func show_kisses():
	if tol.health == 8:
		kisses.show()

func _on_button_nextday_2() -> void:
	next_day_clicked.emit()
