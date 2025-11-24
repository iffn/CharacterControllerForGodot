extends Area3D

class_name Seat

@export var _interaction_text : String
@export var process_when_occupied : Array[Node]
@export var physics_process_when_occupied : Array[Node]
@export var no_process_when_occupied : Array[Node]
@export var no_physics_process_when_occupied : Array[Node]
@export var visible_when_occupied : Array[VisualInstance3D]
@export var invisible_when_occupied : Array[VisualInstance3D]
@export var _sitting_position : Node3D

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
		_occupied_localy = value
		print("updating occupied to " + str(_occupied_localy))
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

func _ready() -> void:
	_update_occupied()
	
