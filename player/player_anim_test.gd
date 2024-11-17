extends CharacterBody3D

#stats
@export var self_speed = 8.0
@export var self_dexterity = 1
@export var self_strength = 1
@export var self_velocity = 100
@export var self_jump = 5

#vars
var speed = self_speed
var jump = 0
var grab = false
var item
var input_dir
var direction

#settings
var sensitive = 0.8
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#nodes
@export var day: _Day

@onready var kinematic = $kinematic
@onready var camera = $kinematic/camera
@onready var ray = $kinematic/camera/ray
@onready var ray_wall = $kinematic/camera/ray_wall
@onready var pin = $kinematic/camera/pin
@onready var neck = $neck
@onready var tween = $tween
@onready var tree = $tree

@onready var aim = $canvas/aim
@onready var ask_panel = $canvas/ask_panel
@onready var ask_button = $"canvas/ask_panel/vbox/1"

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	Global.player = self

func _physics_process(delta: float) -> void:
	#move
	if is_on_floor():
		if direction and Input.mouse_mode == 2:
			velocity.x = move_toward(velocity.x, speed*direction.x, abs(direction.x)*speed/10)
			velocity.z = move_toward(velocity.z, speed*direction.z, abs(direction.z)*speed/10)
			tree.set("parameters/move/blend_amount", lerp(tree.get("parameters/move/blend_amount"), 1.0, 0.05))
			#tween.move(true)
		else:
			tree.set("parameters/move/blend_amount", lerp(tree.get("parameters/move/blend_amount"), 0.0, 0.05))
			#tween.move(false)
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
	neck.rotation.y = lerp_angle(neck.rotation.y, kinematic.rotation.y, float(speed)/50)
	
	#crouch
	if Input.is_action_pressed("ctrl"):
		tree.set("parameters/crouch/add_amount", lerp(tree.get("parameters/crouch/add_amount"), 1.0, 0.05))
		tree.set("parameters/move_scale/scale", lerp(tree.get("parameters/move_scale/scale"), 0.5, 0.05))
		speed = self_speed/2
	else:
		tree.set("parameters/crouch/add_amount", lerp(tree.get("parameters/crouch/add_amount"), 0.0, 0.05))
		tree.set("parameters/move_scale/scale", lerp(tree.get("parameters/move_scale/scale"), 1.0, 0.05))
		speed = self_speed
	
	#grab
	if grab:
		RigidBody3D.new()
		if ray_wall.is_colliding():
			if item.center_of_mass_mode != 0:
				item.set_center_of_mass_mode(RigidBody3D.CENTER_OF_MASS_MODE_AUTO)
			item.linear_velocity = (ray_wall.get_collision_point() - item.global_position)*5
		else:
			if item.center_of_mass_mode != 1:
				item.set_center_of_mass_mode(RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM)
			item.linear_velocity = (pin.global_position - item.global_position)*20
			item.look_at(camera.global_position)
	
	#fps
	$canvas/fps.set_text("FPS %d" % Engine.get_frames_per_second())

func _input(event):
	#mouse
	if event is InputEventMouseMotion:
		if Input.mouse_mode == 2:
			kinematic.rotate_y(-event.relative.x * .001 * sensitive)
			camera.rotate_x(-event.relative.y * .001 * sensitive)
			camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
		else:
			kinematic.rotate_y(-event.relative.x * .001 * sensitive/4)
			camera.rotate_x(-event.relative.y * .001 * sensitive/4)
			camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
	
	#aim_color
	if ray.is_colliding():
		if ray.get_collider():
			aim.label_settings.font_color = Color(0, 1, 0, 0.5)
	else:
		aim.label_settings.font_color = Color(1, 1, 1, 0.5)
	
	if event is InputEventMouseButton:
		if Input.is_action_just_pressed("lmb") and ray.is_colliding():
			#grab
			if ray.get_collider() is RigidBody3D:
				item = ray.get_collider()
				#item.set_center_of_mass_mode(RigidBody3D.CENTER_OF_MASS_MODE_CUSTOM)
				grab = true
				if item.is_in_group("aim"):
					aim.hide()
			#function
			if ray.get_collider() is Area3D:
				item = ray.get_collider()
				if item.has_method("function"):
					item.function()
		#drop
		elif Input.is_action_just_released("lmb") and item is RigidBody3D:
			if item: item.set_center_of_mass_mode(RigidBody3D.CENTER_OF_MASS_MODE_AUTO)
			grab = false
			if !aim.visible:
				aim.show()
	
	if event is InputEventKey:
		#item_function
		if Input.is_action_just_pressed("x") and grab and item:
			if item.has_method("function"):
				item.function()

func ask():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	ask_panel.show()
	ask_button

func sleep():
	self_speed = 0
	gravity = 0
	tree.set("parameters/sleep/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func next_day():
	day.next_day()
