extends MovementModule
class_name Jump

var jump_active: bool = false
var jump_start_velocity = 0

func callable_physics_process(delta: float) -> void:
	
	var on_floor := linked_player_controller.is_on_floor()
	
	var input_jump_just_pressed := linked_player_controller.input_jump_just_pressed
	
	if(!on_floor):
		if(input_jump_just_pressed):
			linked_player_controller.add_vertical_velocity(linked_player_controller.jump_velocity)
			jump_start_velocity = linked_player_controller.vertical_velocity
			jump_active = true
	else:
		# Jump canceling
		if(jump_active 
			&& linked_player_controller.input_jump_just_released
			&& linked_player_controller.vertical_velocity > jump_start_velocity):
			
			linked_player_controller.vertical_velocity = jump_start_velocity
			jump_active = false
