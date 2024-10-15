extends Node3D

func _on_timer_timeout() -> void:
	#doll_event
	var doll = preload("res://items/doll.tscn").instantiate()
	doll.set_rotation(Global.player.get_node("kinematic").get_rotation())
	doll.set_position(Global.player.get_position())
	get_parent().add_child(doll)
	
	#light_event
	#for light in Global.lights.get_children():
		#light.hide()
