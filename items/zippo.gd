extends RigidBody3D

var open = false

func function():
	if open:
		$anim.play_backwards("open")
		open = false
	else:
		$anim.play("open")
		open = true
