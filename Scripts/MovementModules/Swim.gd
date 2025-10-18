extends MovementModule

class_name Swim

func callable_physics_process(delta: float) -> void:
	var in_areas := linked_player_controller.in_areas
	
	for i in range(in_areas.size()):
		var fluid := in_areas[i] as Fluid
		if(fluid):
			print("swim")
