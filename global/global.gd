extends Node

var player: Node
var lights: Node

signal update_list_signal

var list = {
	"test1": false,
	"test2": false,
}

func update_list_item():
	update_list_signal.emit()
