extends RigidBody3D

@onready var label = $c/label

func _ready() -> void:
	Global.update_list_signal.connect(update_list)
	label.text = "list:" + str(Global.list)

func update_list():
	label.text = "list:" + str(Global.list)
