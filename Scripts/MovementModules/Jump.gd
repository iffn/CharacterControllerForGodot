extends MovementModule
class_name Jump

var jump_active: bool = false
var jump_start_velocity = 0

func _physics_process(delta: float) -> void:
	if(linked_player_controller.is_on_floor()):
		if(linked_player_controller.input_jump_just_pressed):
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
