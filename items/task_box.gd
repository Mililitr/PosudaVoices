extends StaticBody3D

func _on_area_body_entered(body: Node3D) -> void:
	if body is RigidBody3D:
		Global.list["test1"] = true
		Global.update_list_item()
