extends MovementModule

class_name SwimDetector

@export var _swim_system_to_switch_to : MovementSystem

func in_fluid(sample_point_world: Vector3) -> bool:
	var in_areas := linked_player_controller.in_areas
	for i in range(in_areas.size()):
		var fluid := in_areas[i] as Fluid
		if(fluid):
			if(fluid.in_fluid(sample_point_world)):
				return true
	return false

func callable_physics_process(delta: float) -> void:
	if(_swim_system_to_switch_to):
		if(in_fluid(linked_player_controller.head_position_world)):
			linked_player_controller.current_movement_system = _swim_system_to_switch_to
