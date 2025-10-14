extends MovementModule
class_name WalkAndRun

func callable_physics_process(delta: float) -> void:
	
	var forward_speed: float
	
	var input: Vector2 = linked_player_controller.input_move_direction_fwd_right
	
	# Only sprint when going forward,
	if(input.x > 0):
		forward_speed = lerp(
			linked_player_controller.walk_speed,
			linked_player_controller.run_speed,
			linked_player_controller.input_sprint
			)
	else:
		forward_speed = linked_player_controller.walk_speed
	
	var new_velocity: Vector2 = Vector2(
		forward_speed,
		linked_player_controller.walk_speed
	)
	
	new_velocity *= linked_player_controller.input_move_direction_fwd_right
	
	linked_player_controller.relative_horizontal_velocity_fwd_right = new_velocity
