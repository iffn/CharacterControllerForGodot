extends CharacterBody3D

@export var head: Node3D

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002

var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var yaw := 0.0
var pitch := 0.0

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event):
	# Mouse rotation
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-90), deg_to_rad(90))
		rotation.y = yaw
		head.rotation.x = pitch
	
	# Unlock mouse when pressing escape
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _physics_process(delta):
	var v = velocity
	
	# Horizontal velocity from movement inputs
	var input_dir = Vector3.ZERO
	input_dir.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	input_dir.z = Input.get_action_strength("move_backward") - Input.get_action_strength("move_forward")
	input_dir = input_dir.normalized()
	var direction = (transform.basis * input_dir).normalized()
	var horizontal_velocity = direction * speed
	v.x = horizontal_velocity.x
	v.z = horizontal_velocity.z

	# Vertical velocity from falling and jumping
	if not is_on_floor():
		v.y -= gravity * delta
	
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		v.y = jump_velocity
	
	# Applying velocity
	velocity = v
	
	## Sliding
	
	# Friction formulas:
	# ------------------
	# α = acos(Ny)
	#   = atan(µ)
	
	# Ny = cos(α)
  	#    = cos(atan(µ))
		
	# µ = tan(α)
	#   = tan(acos(Ny)
		
	# α = slope angle
	# Ny = Normalized normal y
	# µ = Friction coefficient
	
	if is_on_floor():
		var μ = get_floor_friction()
		var max_angle = atan(μ)
		floor_max_angle = max_angle
	
	move_and_slide()

func get_floor_collision() -> KinematicCollision3D:
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.get_normal().dot(Vector3.UP) > sin(deg_to_rad(5.0)):
			return collision
	return null

func get_floor_friction() -> float:
	var col := get_floor_collision()
	if col == null:
		return 1.0

	var collider := col.get_collider()
	if collider is PhysicsBody3D and collider.physics_material_override:
		return collider.physics_material_override.friction

	# Check child CollisionShapes (in case material is defined there)
	# Throws error...
	#if collider is Node3D:
		#for child in collider.get_children():
			#if child is CollisionShape3D and child.physics_material_override:
				#return child.physics_material_override.friction

	return 1.0
