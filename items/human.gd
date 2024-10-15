extends Node3D

func _on_area_body_entered(body: Node3D) -> void:
	print(body)
	if body.is_in_group("players"):
		print("ASD")
		Global.player.ask()
