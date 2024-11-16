extends "res://days/day.gd"

func _ready() -> void:
	day = 1
	list.tasks = {
		"s1" = false,
		"s2" = false,
	}
