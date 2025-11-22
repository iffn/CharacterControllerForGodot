extends MovementModule
class_name Turn

func callable_process(delta: float) -> void:
	_set_body_rotation(delta)
	_set_head_rotation(delta)

func _set_body_rotation(delta: float) -> void:
	var rot := linked_player_controller.body_visual_rotation_relative
	rot.y -= linked_player_controller.input_mouse_turn.x
	linked_player_controller.body_visual_rotation_relative = rot

func _set_head_rotation(delta: float) -> void:
	var hrot := linked_player_controller.head_rotation
	hrot.x -= linked_player_controller.input_mouse_turn.y
	linked_player_controller.head_rotation = hrot
