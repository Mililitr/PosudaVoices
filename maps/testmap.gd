extends Node3D

func _physics_process(delta: float) -> void:
	$prikol/p.global_position = $player_anim_test/kinematic/camera/pin.global_position
