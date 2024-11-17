extends Node3D
class_name _Day

@export var list: _Item_List
@export var anim: AnimationPlayer
@export var day: int

var days = [
	"res://days/day_1.tscn",
	"res://days/day_2.tscn"
]

var completed = false

func sleep():
	anim.play("sleep")

func next_day():
	get_tree().change_scene_to_file(days[day + 1])
