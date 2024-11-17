extends "res://days/day.gd"

func _ready() -> void:
	list.tasks = {
		"cups": false,
		"plates": false,
	}
	list.update_tasks()
