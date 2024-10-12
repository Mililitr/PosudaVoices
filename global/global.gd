extends Node

var list = {
	"test1": false,
	"test2": false,
}

var days = 6
var day = 1
var completed = false

var player: Node
var lights: Node

signal update_list_signal

func update_list_item():
	update_list_signal.emit()
	for task in list:
		if !list[task]:
			return
	completed = true
	print(completed)
