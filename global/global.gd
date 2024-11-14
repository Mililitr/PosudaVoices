extends Node

var list = {
	"test1": false,
	"test2": false,
}

var days = 6
var day = 1
var day_completed = false

var map: Node
var player: Node
var lights: Node

signal update_list_signal

func update_list_item():
	update_list_signal.emit()
	for task in list:
		if !list[task]:
			return
	day_completed = true
	

func sleep():
	player.sleep()

func next_day():
	map.restart()
	day += 1
	day_completed = false
