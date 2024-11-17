extends Area3D

@export var day: Node3D

func function():
	if day.completed:
		day.sleep()
	else:
		$anim.play("label")
