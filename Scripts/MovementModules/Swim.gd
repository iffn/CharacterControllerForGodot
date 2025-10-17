extends MovementModule

class_name Swim

func callable_physics_process(delta: float) -> void:
	var colliders := linked_player_controller.floor_colliders
	
	
