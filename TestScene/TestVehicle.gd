extends Node3D

@export var speed := 3.0
@export var forward_input = "move_forward"
@export var backward_input = "move_backward"
@export var strafe_left_input = "move_left"
@export var strafe_right_input = "move_right"
@export var turn_left_input = "lean_left"
@export var turn_right_input = "lean_right"

func _process(delta: float) -> void:
	var orientation := global_transform.basis
	var forward := -orientation.z.normalized()
	var right := orientation.x.normalized()
	
	var delta_speed = speed * delta
	
	if(Input.is_action_pressed(forward_input)):
		global_position += delta_speed * forward
	
	if(Input.is_action_pressed(backward_input)):
		global_position -= delta_speed * forward
	
	if(Input.is_action_pressed(strafe_left_input)):
		global_position -= delta_speed * right
	
	if(Input.is_action_pressed(strafe_right_input)):
		global_position += delta_speed * right
	
	if(Input.is_action_pressed(turn_left_input)):
		rotate(Vector3(0,1,0), delta_speed)
	
	if(Input.is_action_pressed(turn_right_input)):
		rotate(Vector3(0,1,0), -delta_speed)
