# FirstPersonPlayerController.gd
extends CharacterBody3D

class_name FirstPersonPlayerController

# --- Inspector assignments ---
@export var _body_visual: Node3D
@export var _head: Node3D
@export var _default_movement_system: MovementSystem
@export var _walk_speed: float = 5.0
@export var _run_speed: float = 10.0
@export var _jump_velocity: float = 4.5
@export var _mouse_sensitivity: float = 0.002
@export var _collider: CollisionShape3D

# --- Direct access ---
var mouse_sensitivity: float:
	get:
		return _mouse_sensitivity

# --- Internal values ---
var GRAVITY: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _input_mouse_turn: Vector2 = Vector2.ZERO
var _current_movement_system: MovementSystem
var _collider_height_original: float
var _height_multiplier: float
var _head_position_original: Vector3
var _in_areas: Array[Area3D]
var _physics_active := true

# --- System management ---
var current_movement_system: MovementSystem:
	set(value):
		if _current_movement_system:
			_current_movement_system.disable()
		_current_movement_system = value
		if _current_movement_system:
			_current_movement_system.setup(self)
			_current_movement_system.enable()
	get:
		return _current_movement_system

func reparent_visual_body_if_assigned(new_parent : Node3D):
	var switch_back := new_parent == null
	
	_physics_active = switch_back
	set_physics_process(switch_back)
	_collider.disabled = not switch_back
	
	if(switch_back):
		global_position = _body_visual.global_position
		global_rotation = _body_visual.global_rotation
		_body_visual.reparent(self)
		rotation = Vector3(0,rotation.y,0)
	else:
		_body_visual.reparent(new_parent)
		_body_visual.position = Vector3(0,0,0)
		_body_visual.rotation = Vector3(0,0,0)

# --- Settng access ---
var walk_speed: float:
	get:
		return _walk_speed

var run_speed: float:
	get:
		return _run_speed

var jump_velocity: float:
	get:
		return _jump_velocity

# --- Input ---
var input_mouse_turn: Vector2:
	get:
		return _input_mouse_turn

var input_move_direction_fwd_right: Vector2:
	get: 
		var return_value := Vector2.ZERO
		return_value.x = Input.get_action_strength("move_forward") - Input.get_action_strength("move_backward")
		return_value.y = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
		return_value = return_value.normalized()
		return return_value

var input_jump_just_pressed: bool:
	get:
		return Input.is_action_just_pressed("jump")

var input_jump_just_released: bool:
	get:
		return Input.is_action_just_released("jump")

var input_jump_pressed_or_held: bool:
	get:
		return Input.is_action_pressed("jump")

var input_sprint: float:
	get:
		return Input.get_action_strength("sprint")

# --- Position ---
var head_position_world: Vector3:
	get:
		return _head.global_position

# --- Rotation ---
var body_visual_rotation_relative: Vector3:
	set(value):
		# Use the local transform instead of the global transform
		var t := _body_visual.transform
		t.basis = Basis.from_euler(value)
		_body_visual.transform = t
	get:
		# Return the euler angles from the local transform
		return _body_visual.transform.basis.get_euler()

var body_visual_rotation_world: Vector3:
	set(value):
		var t := _body_visual.global_transform
		t.basis = Basis.from_euler(value)
		_body_visual.global_transform = t
	get:
		return _body_visual.global_transform.basis.get_euler()

var head_rotation: Vector3:
	get: 
		return _head.rotation
	set(value):
		_head.rotation = value

var look_direction_world: Vector3:
	get:
		return -_head.global_transform.basis.z.normalized() # Negative since -z = forward

func convert_from_head_to_body(head_local_vector: Vector3) -> Vector3:
	# Convert the direction from head's local space to world space
	var world_vector = _head.global_transform.basis * head_local_vector
	# Convert the world direction to body's local space
	return global_transform.basis.inverse() * world_vector

# --- Velocity ---
var relative_horizontal_velocity_fwd_right: Vector2:
	get:
		var v_world: Vector3 = velocity
		var base: Basis = global_transform.basis
		var v_local: Vector3 = base.inverse() * v_world
		return Vector2(-v_local.z, v_local.x) # (forward, right)
	set(value):
		var v_world: Vector3 = velocity
		var base: Basis = global_transform.basis
		var v_local: Vector3 = base.inverse() * v_world
		v_local.x = value.y      # right
		v_local.z = -value.x     # forward
		var new_world: Vector3 = base * v_local
		velocity = Vector3(new_world.x, v_world.y, new_world.z)

var vertical_velocity: float:
	get:
		return velocity.y
	set(value):
		var v := velocity
		v.y = value
		velocity = v

func add_vertical_velocity(value: float) -> void:
	var v := velocity
	v.y += value
	velocity = v

# Areas and colisions
func enter_area (area: Area3D) -> void:
	if(_in_areas.count(area) == 0):
		_in_areas.append(area)

func exit_area (area: Area3D) -> void:
	_in_areas.erase(area)

var in_areas: Array[Area3D]:
	get:
		return _in_areas

var floor_colliders: Array[KinematicCollision3D]:
	get:
		var collisions: Array[KinematicCollision3D] = []
		for i in range(get_slide_collision_count()):
			collisions.append(get_slide_collision(i))
		return collisions

var physics_space: PhysicsDirectSpaceState3D:
	get:
		return self.get_world_3d().direct_space_state

# Size
var height_multiplier: float:
	set(value):
		_height_multiplier = value
		
		var capsule = $CollisionShape3D.shape as CapsuleShape3D
		if(capsule):
			capsule.height = _collider_height_original * _height_multiplier
		
		var collision_shape = $CollisionShape3D
		collision_shape.position.y = _collider_height_original * _height_multiplier * 0.5
		
		var head_position := _head.position
		head_position.y = _head_position_original.y * _height_multiplier
		_head.position = head_position

# --- Built in functions ---
func _ready() -> void:
	_current_movement_system = _default_movement_system
	if _current_movement_system:
		_current_movement_system.setup(self)
		_current_movement_system.enable()
	
	var capsule = $CollisionShape3D.shape as CapsuleShape3D
	if(capsule):
		_collider_height_original = capsule.height
	
	_head_position_original = _head.position
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	_default_movement_system.enable()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if _current_movement_system:
		_current_movement_system.input_event(event)

func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	if(_physics_active):
		var current_rotation_visual := _body_visual.rotation
		var current_rotation = rotation
		current_rotation += current_rotation_visual
		rotation = current_rotation
		_body_visual.rotation = Vector3.ZERO
	
	if(_physics_active):
		move_and_slide()
