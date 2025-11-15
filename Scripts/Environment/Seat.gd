extends Area3D

class_name Seat

@export var _sitting_position : Node3D

var sitting_position : Node3D:
	get:
		return _sitting_position

var occupied := false
