extends MovementModule
class_name WalkAndRun

func callable_process(delta: float) -> void:
	
	var forward_speed: float = lerp(
		linked_player_controller.walk_speed,
		linked_player_controller.run_speed,
		linked_player_controller.input_sprint
	)
	
	var new_velocity: Vector2 = Vector2(
		forward_speed,
		linked_player_controller.walk_speed
	)
	
	new_velocity *= linked_player_controller.input_move_direction
	
	linked_player_controller.relative_horizontal_velocity_fwd_right = new_velocity
