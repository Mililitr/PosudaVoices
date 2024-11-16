extends Node3D
class_name _Day

@export var list: _Item_List

var day = 0
var days = [
	"res://days/day_1.tscn",
	"res://days/day_2.tscn"
]

var completed = false

func sleep():
	get_tree().change_scene_to_file(days[day])
