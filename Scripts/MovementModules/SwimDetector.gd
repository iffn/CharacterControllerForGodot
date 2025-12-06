extends MovementModule

class_name SwimDetector

@export var _swim_system_to_switch_to : MovementSystem
@export var _movement_system_to_switch_to : MovementSystem

var _swimming := false

func in_fluid(sample_point_world: Vector3) -> bool:
	var in_areas := linked_player_controller.in_areas
	for i in range(in_areas.size()):
		var fluid := in_areas[i] as Fluid
		if(fluid):
			if(fluid.in_fluid(sample_point_world)):
				return true
	return false

func _physics_process(delta: float) -> void:
	if(_swimming):
		if(_movement_system_to_switch_to):
			if(!in_fluid(linked_player_controller.head_position_world)
				&& linked_player_controller.is_on_floor()):
				linked_player_controller.current_movement_system = _movement_system_to_switch_to
				_swimming = false
	else:
		if(_swim_system_to_switch_to):
			if(in_fluid(linked_player_controller.head_position_world)):
				linked_player_controller.current_movement_system = _swim_system_to_switch_to
				_swimming = true
