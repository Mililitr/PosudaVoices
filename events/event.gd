extends Node3D

func _on_timer_timeout() -> void:
	#doll_event
	var doll = preload("res://items/doll.tscn").instantiate()
	doll.global_position = Global.player.global_position
	get_parent().add_child(doll)
	
	#light_event
	#for light in Global.lights.get_children():
		#light.hide()
