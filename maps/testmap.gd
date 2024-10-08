extends Node3D

func _ready() -> void:
	Global.lights = $lights

func _physics_process(delta: float) -> void:
	$prikol/p.global_position = $player/kinematic/camera/pin.global_position
