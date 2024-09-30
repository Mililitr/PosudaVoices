extends CharacterBody3D

#stats
@export var self_speed = 8
@export var self_dexterity = 1
@export var self_strength = 1
@export var self_velocity = 100
@export var self_jump = 5

#vars
var speed = self_speed
var jump = 0
var input_dir
var direction

#settings
var sensitive = 0.8
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#nodes
@onready var kinematic = $kinematic
@onready var camera = $kinematic/camera
@onready var neck = $neck
@onready var legs = $neck/legs
@onready var anim = $anim

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	#move
	if is_on_floor():
		if direction:
			velocity.x = move_toward(velocity.x, speed*direction.x, abs(direction.x)*speed/10)
			velocity.z = move_toward(velocity.z, speed*direction.z, abs(direction.z)*speed/10)
			if anim.current_animation != "move":
				anim.play("move")
		elif anim.current_animation != "idle":
				anim.play("idle")
		velocity.x = move_toward(velocity.x, 0, abs(velocity.x)/10)
		velocity.z = move_toward(velocity.z, 0, abs(velocity.z)/10)
	elif direction:
		velocity.x = move_toward(velocity.x, speed*direction.x, abs(direction.x)/8)
		velocity.z = move_toward(velocity.z, speed*direction.z, abs(direction.z)/8)
	
	#gravity
	if !is_on_floor(): velocity.y -= gravity*delta 
	
	move_and_slide()
	
	#direction
	input_dir = Input.get_vector("a", "d", "w", "s")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).rotated(Vector3.UP, kinematic.rotation.y)
	
	#neck_rotation
	neck.rotation.y = lerp_angle(neck.rotation.y, kinematic.rotation.y, float(speed)/40)

func _input(event):
	#mouse
	if event is InputEventMouseMotion:
		kinematic.rotate_y(-event.relative.x * .001 * sensitive)
		camera.rotate_x(-event.relative.y * .001 * sensitive)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	#tween_test
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("lmb"):
			anim.play("lmb")
