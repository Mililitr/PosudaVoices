extends Area3D

@export var list: _Item_List
@export_enum("cups", "plates", "towels") var item_group: String
@export var task: int

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group(item_group):
		list.complete_task(task)
