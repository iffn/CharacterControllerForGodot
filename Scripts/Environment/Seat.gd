extends Area3D

class_name Seat

@export var _sitting_position : Node3D
@export var linked_scrpit : Node
@export var toggle_physics_process : bool = false
@export var visualization : VisualInstance3D

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
	if(linked_scrpit != null):
		linked_scrpit.set_process(_occupied_localy)
		if(toggle_physics_process):
			linked_scrpit.set_physics_process(_occupied_localy)
	if(visualization != null):
		visualization.visible = !occupied_localy

func _ready() -> void:
	_update_occupied()
	
