extends Area3D

@export var day: Node3D

func _ready() -> void:
	day = get_parent_node_3d()

func function():
	if day.completed:
		day.sleep()
	else:
		$anim.play("label")
