extends "res://events/event.gd"

func _on_timer_timeout() -> void:
	Global.list = {
		"СТ1 Кружка 1234": false,
		"СТ2 Тарелка 2345": false,
	}
