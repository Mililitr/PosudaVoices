extends Area3D

func function():
	if Global.day_completed:
		Global.sleep()
	else:
		$anim.play("label")
