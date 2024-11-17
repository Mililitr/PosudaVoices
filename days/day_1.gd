extends "res://days/day.gd"

@export var anim: AnimationPlayer

func _ready() -> void:
	list.tasks = {
		"cups": false,
		"plates": false,
	}
	list.update_tasks()

func sleep():
	anim.play("sleep")

func next_day():
	get_tree().change_scene_to_file(days[1])
