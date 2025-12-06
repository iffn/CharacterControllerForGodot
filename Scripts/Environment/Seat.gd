extends Area3D

class_name Seat

@export var _interaction_text : String
@export var _sitting_position : Node3D

@export var process_when_occupied : Array[Node]
@export var physics_process_when_occupied : Array[Node]
@export var no_process_when_occupied : Array[Node]
@export var no_physics_process_when_occupied : Array[Node]
@export var visible_when_occupied : Array[VisualInstance3D]
@export var invisible_when_occupied : Array[VisualInstance3D]

@export var process_mode_enabled_when_occupied : Array[Node]
@export var process_mode_disabled_when_occupied : Array[Node]


@export var idle_visualizer : Node3D
@export var active_visualizer : Node3D

enum Activations {
	INVISIBLE,
	IDLE,
	ACTIVE,
}

var _activation_state : Activations

var activation_state : Activations:
	set(value):
		if(_occupied_localy && _activation_state != Activations.INVISIBLE):
			return
		
		_activation_state = value
		match value:
			Activations.INVISIBLE:
				idle_visualizer.visible = false
				active_visualizer.visible = false
			Activations.IDLE:
				idle_visualizer.visible = true
				active_visualizer.visible = false
			Activations.ACTIVE:
				idle_visualizer.visible = false
				active_visualizer.visible = true

var interaction_text : String:
	get:
		return _interaction_text

var sitting_position : Node3D:
	get:
		return _sitting_position

var _occupied_localy := false

var occupied_localy : bool:
	get:
		return _occupied_localy
	set(value):
		if(_occupied_localy != value):
			_occupied_localy = value
			_update_occupied()

func _update_occupied() -> void:
	for node in process_when_occupied:
		node.set_process(_occupied_localy)
		
	for node in physics_process_when_occupied:
		node.set_physics_process(_occupied_localy)
	
	for node in no_process_when_occupied:
		node.set_process(!_occupied_localy)
		
	for node in no_physics_process_when_occupied:
		node.set_physics_process(!_occupied_localy)
	
	for node in visible_when_occupied:
		node.visible = occupied_localy
	
	for node in invisible_when_occupied:
		node.visible = !occupied_localy
	
	for node in process_mode_enabled_when_occupied:
		node.process_mode = Node.PROCESS_MODE_INHERIT if occupied_localy else Node.PROCESS_MODE_DISABLED
	
	for node in process_mode_disabled_when_occupied:
		node.process_mode = Node.PROCESS_MODE_DISABLED if occupied_localy else Node.PROCESS_MODE_INHERIT
	
	if(occupied_localy):
		activation_state = Activations.INVISIBLE
	else:
		activation_state = Activations.IDLE

func _ready() -> void:
	_update_occupied()
	activation_state = Activations.IDLE
