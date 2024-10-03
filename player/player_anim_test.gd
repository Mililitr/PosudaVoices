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
@onready var ray = $kinematic/camera/ray
@onready var pin = $kinematic/camera/pin
@onready var neck = $neck
@onready var tween = $tween

@onready var aim = $canvas/aim

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	#move
	if is_on_floor():
		if direction:
			velocity.x = move_toward(velocity.x, speed*direction.x, abs(direction.x)*speed/10)
			velocity.z = move_toward(velocity.z, speed*direction.z, abs(direction.z)*speed/10)
			tween.move(true)
		else:
			tween.move(false)
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
	
	#crouch
	if Input.is_action_pressed("ctrl"):
		kinematic.position.y = lerp(kinematic.position.y, 0.2, 0.2)
	else:
		kinematic.position.y = lerp(kinematic.position.y, 0.8, 0.2)
	
	#fps
	$canvas/fps.set_text("FPS %d" % Engine.get_frames_per_second())

func _input(event):
	#mouse
	if event is InputEventMouseMotion:
		kinematic.rotate_y(-event.relative.x * .001 * sensitive)
		camera.rotate_x(-event.relative.y * .001 * sensitive)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	#aim_color
	if ray.is_colliding():
		if ray.get_collider() is RigidBody3D:
			aim.label_settings.font_color = Color(0, 1, 0, 0.5)
	else:
		aim.label_settings.font_color = Color(1, 1, 1, 0.5)
	
	if event is InputEventMouseButton:
		#grab
		if Input.is_action_just_pressed("lmb") and ray.is_colliding():
			if ray.get_collider() is RigidBody3D:
				pin.global_position = ray.get_collider().global_position
				pin.node_b = ray.get_collider().get_path()
		elif Input.is_action_just_released("lmb"):
			if pin.node_b:
				pin.node_b = ""
