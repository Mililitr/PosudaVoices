extends RigidBody3D

@onready var label = $c/label

func _ready() -> void:
	Global.update_list_signal.connect(update_list)
	update_list()

func update_list():
	label.text = "list:\n"
	for task in Global.list:
		label.text += task + " - " + ("YES" if Global.list[task] else "NO") + "\n"
