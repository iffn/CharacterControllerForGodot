extends MovementModule

class_name SwimDetector

@export var _swim_system_to_switch_to : MovementSystem

var in_water: bool:
	get:
		var in_areas := linked_player_controller.in_areas
		for i in range(in_areas.size()):
			var fluid := in_areas[i] as Fluid
			if(fluid):
				return true
		return false

func callable_physics_process(delta: float) -> void:
	if(_swim_system_to_switch_to && in_water):
		linked_player_controller.current_movement_system = _swim_system_to_switch_to
