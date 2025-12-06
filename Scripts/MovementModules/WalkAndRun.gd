extends MovementModule
class_name WalkAndRun

func _physics_process(delta: float) -> void:
	# Get input
	var input: Vector2 = linked_player_controller.input_move_direction_fwd_right
	
	# Determine forward speed. Only sprint when going forward,
	var forward_speed: float
	
	if(input.x > 0):
		forward_speed = lerp(
			linked_player_controller.walk_speed,
			linked_player_controller.run_speed,
			linked_player_controller.input_sprint
			)
	else:
		forward_speed = linked_player_controller.walk_speed
	
	# Determine and apply new velocity.
	var new_velocity: Vector2 = Vector2(
		forward_speed,
		linked_player_controller.walk_speed
	)
	
	new_velocity *= input.normalized() # Prevent angeled walking being faster
	
	linked_player_controller.relative_horizontal_velocity_fwd_right = new_velocity
