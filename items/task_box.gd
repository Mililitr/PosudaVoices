extends StaticBody3D

func _on_area_body_entered(body: Node3D) -> void:
	if body is RigidBody3D and body.is_in_group("cups"):
		Global.list["test1"] = true
		Global.update_list_item()
	elif body is RigidBody3D and body.is_in_group("plates"):
		Global.list["test2"] = true
		Global.update_list_item()
