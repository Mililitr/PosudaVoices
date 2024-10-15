extends Node3D

@export var player: CharacterBody3D
@export var spawn: Node3D

func _ready() -> void:
	Global.map = self
	Global.lights = $lights

func restart():
	player.global_position = spawn.global_position
