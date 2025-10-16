extends MovementModule

class_name Crouch

@export var _crouch_height_factor: float = 0.5

func callable_physics_process(delta: float) -> void:
	if(Input.is_action_just_pressed("crouch")):
		linked_player_controller.height_multiplier = _crouch_height_factor
		
	if(Input.is_action_just_released("crouch")):
		linked_player_controller.height_multiplier = 1
