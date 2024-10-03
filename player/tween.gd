extends Node3D

#nodes
@export var kinematic: Node
@export var body: Node
@export var ll: Node
@export var lr: Node

#tweens
var tween_idle: Tween
var tween_move: Tween
var tween_stand: Tween
var tween_crouch: Tween

#vars
@export var duration: float

func _ready() -> void:
	ready_tween_idle()
	ready_tween_move()
	ready_tween_stand()
	ready_tween_crouch()

func ready_tween_idle():
	tween_idle = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween_idle.set_loops()
	tween_idle.set_parallel()
	tween_idle.stop()
	
	tween_idle.tween_property(ll, "rotation_degrees:x", 0, duration)
	tween_idle.tween_property(lr, "rotation_degrees:x", 0, duration)
	tween_idle.tween_property(kinematic, "position:y", 0, duration/2).from_current()

func ready_tween_move():
	tween_move = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween_move.set_loops()
	tween_move.set_parallel()
	tween_move.stop()
	
	tween_move.tween_callback(kinematic_tween_move)
	tween_move.tween_property(ll, "rotation_degrees:x", 45, duration)
	tween_move.tween_property(lr, "rotation_degrees:x", -45, duration)
	tween_move.chain().tween_callback(kinematic_tween_move)
	tween_move.tween_property(ll, "rotation_degrees:x", -45, duration)
	tween_move.tween_property(lr, "rotation_degrees:x", 45, duration)

func kinematic_tween_move():
	var _t = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	_t.tween_property(kinematic, "position:y", -0.1, duration/2)
	_t.tween_property(kinematic, "position:y", 0, duration/2)

func ready_tween_stand():
	tween_stand = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween_stand.set_loops()
	tween_stand.set_parallel()
	tween_stand.stop()
	
	tween_stand.tween_property(kinematic, "position:y", 0.8, duration).from_current()
	tween_stand.tween_property(body, "rotation_degrees:x", 0, duration).from_current()

func ready_tween_crouch():
	tween_crouch = create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween_crouch.set_loops()
	tween_crouch.set_parallel()
	tween_crouch.stop()
	
	tween_crouch.tween_property(kinematic, "position:y", 0.2, duration)
	tween_crouch.tween_property(body, "rotation_degrees:x", -45, duration)

func move(_t: bool):
	if _t:
		tween_idle.stop()
		tween_move.play()
	else:
		tween_move.stop()
		tween_idle.play()

func crouch(_t: bool):
	if _t:
		tween_stand.stop()
		tween_crouch.play()
	else:
		tween_crouch.stop()
		tween_stand.play()
