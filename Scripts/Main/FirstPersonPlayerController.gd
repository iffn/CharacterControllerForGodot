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

# --- Internal values ---
var GRAVITY: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var _input_mouse_turn: Vector2 = Vector2.ZERO
var _current_movement_system: MovementSystem
var _collider_height_original: float
var _height_multiplier: float
var _head_position_original: Vector3
var _in_areas: Array[Area3D]

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
		return Input.is_action_just_pressed("jump")

var input_sprint: float:
	get:
		return Input.get_action_strength("sprint")

# --- Position ---
var head_position_world: Vector3:
	get:
		return _head.global_position

# --- Rotation ---
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
	
	var capsule = $CollisionShape3D.shape as CapsuleShape3D
	if(capsule):
		_collider_height_original = capsule.height
	
	_head_position_original = _head.position
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mm := event as InputEventMouseMotion
		var x := mm.relative.x * _mouse_sensitivity
		var y := mm.relative.y * _mouse_sensitivity
		_input_mouse_turn += Vector2(x, y)

	# Unlock mouse when pressing Escape
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	if _current_movement_system:
		_current_movement_system.callable_process(delta)
	
	_input_mouse_turn = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var current_rotation_visual := _body_visual.rotation
	var current_rotation = rotation
	current_rotation += current_rotation_visual
	rotation = current_rotation
	_body_visual.rotation = Vector3.ZERO
	
	if _current_movement_system:
		_current_movement_system.callable_physics_process(delta)
		
	move_and_slide()
