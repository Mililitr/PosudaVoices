extends RigidBody3D
class_name _Item_List

@export var day: _Day

@onready var label = $c/label

var tasks = {}

func _ready() -> void:
	update_list()

func complete_task(task):
	tasks[task] = true
	update_list()

func update_list():
	var completed = true
	for task in tasks:
		label.text += task + " - " + ("YES" if tasks[task] else "NO") + "\n"
		if !task: completed = false
	if completed: day.completed = true

#func _ready() -> void:
	#Global.update_list_signal.connect(update_list)
	#update_list()
#
#func update_list():
	#label.text = "list:\n"
	#for task in Global.list:
		#label.text += task + " - " + ("YES" if Global.list[task] else "NO") + "\n"
