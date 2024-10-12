extends RigidBody3D

var open = false

func function():
	if open:
		$anim.play_backwards("open")
		$c/part.hide()
		open = false
	else:
		$anim.play("open")
		$c/part.show()
		open = true
