extends Area3D

class_name Seat

@export var _sitting_position : Node3D
@export var linked_scrpit : Node

var sitting_position : Node3D:
	get:
		return _sitting_position

var _occupied_localy := false

var occupied_localy : bool:
	get:
		return _occupied_localy
	set(value):
		_occupied_localy = value
		linked_scrpit.set_process(value)

func _ready() -> void:
	linked_scrpit.set_process(_occupied_localy)
