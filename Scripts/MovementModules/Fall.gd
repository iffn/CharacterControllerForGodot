extends MovementModule
class_name Fall

func _physics_process(delta: float) -> void:
	if(!linked_player_controller.is_on_floor()):
		linked_player_controller.add_vertical_velocity(-linked_player_controller.GRAVITY * delta)
