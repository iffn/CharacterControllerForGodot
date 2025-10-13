# FirstPersonPlayerController.gd
extends CharacterBody3D

class_name FirstPersonPlayerController

@export var body_visual: Node3D
@export var head: Node3D
@export var walk_speed: float = 5.0
@export var run_speed: float = 10.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.002

@export var default_movement_system: MovementSystem

var GRAVITY: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var input_mouse_turn: Vector2 = Vector2.ZERO

# --- Movement system management ---
var _current_movement_system: MovementSystem

func set_body_visual_rotation_world(value: Vector3) -> void:
	var t := body_visual.global_transform
	t.basis = Basis.from_euler(value)
	body_visual.global_transform = t

func get_body_visual_rotation_world() -> Vector3:
	return body_visual.global_transform.basis.get_euler()

func set_current_movement_system(value: MovementSystem) -> void:
	if _current_movement_system:
		_current_movement_system.disable()
	_current_movement_system = value
	if _current_movement_system:
		_current_movement_system.setup(self)
		_current_movement_system.enable()

func get_current_movement_system() -> MovementSystem:
	return _current_movement_system

# Expose as a property if you want get/set syntax:
# var current_movement_system: MovementSystem:
# 	get: return get_current_movement_system()
# 	set(value): set_current_movement_system(value)

# --- Head rotation proxy ---
func get_head_rotation() -> Vector3:
	return head.rotation

func set_head_rotation(rot: Vector3) -> void:
	head.rotation = rot

# --- Relative horizontal velocity (Forward/Right) ---
func get_relative_horizontal_velocity_fwd_right() -> Vector2:
	var v_world: Vector3 = velocity
	var basis: Basis = global_transform.basis
	var v_local: Vector3 = basis.inverse() * v_world
	return Vector2(-v_local.z, v_local.x) # (forward, right)

func set_relative_horizontal_velocity_fwd_right(v: Vector2) -> void:
	var v_world: Vector3 = velocity
	var basis: Basis = global_transform.basis
	var v_local: Vector3 = basis.inverse() * v_world

	# Replace horizontal components; keep vertical world Y
	v_local.x = v.y      # right
	v_local.z = -v.x     # forward

	var new_world: Vector3 = basis * v_local
	velocity = Vector3(new_world.x, v_world.y, new_world.z)

# --- Vertical velocity proxy ---
func get_vertical_velocity() -> float:
	return velocity.y

func set_vertical_velocity(vy: float) -> void:
	var v := velocity
	v.y = vy
	velocity = v

func _ready() -> void:
	_current_movement_system = default_movement_system
	if _current_movement_system:
		_current_movement_system.setup(self)

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mm := event as InputEventMouseMotion
		var x := mm.relative.x * mouse_sensitivity
		var y := mm.relative.y * mouse_sensitivity
		input_mouse_turn += Vector2(x, y)

	# Unlock mouse when pressing Escape
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta: float) -> void:
	if _current_movement_system:
		_current_movement_system.callable_process(delta)
	
	input_mouse_turn = Vector2.ZERO

func _physics_process(delta: float) -> void:
	var current_rotation_visual := body_visual.rotation
	var current_rotation = rotation
	current_rotation += current_rotation_visual
	rotation = current_rotation
	body_visual.rotation = Vector3.ZERO
	
	if _current_movement_system:
		_current_movement_system.callable_physics_process(delta)
