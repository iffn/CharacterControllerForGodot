extends Interactible

@export var respawn_object : Node3D

var original_global_position : Vector3
var original_global_rotation : Vector3

func _ready() -> void:
	if(!respawn_object):
		return
	
	original_global_position = respawn_object.global_position
	original_global_rotation = respawn_object.global_rotation

func  Interact() -> void:
	if(!respawn_object):
		return
	
	respawn_object.global_position = original_global_position
	respawn_object.global_rotation = original_global_rotation
	
	if(respawn_object is RigidBody3D):
		var rigidbody = respawn_object as RigidBody3D
		rigidbody.linear_velocity = Vector3.ZERO
		rigidbody.angular_velocity = Vector3.ZERO
