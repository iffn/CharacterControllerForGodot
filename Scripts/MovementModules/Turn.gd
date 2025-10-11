extends MovementModule
class_name Turn

func physics_process(delta: float) -> void:
	_set_body_rotation(delta)
	_set_head_rotation(delta)

func _set_body_rotation(delta: float) -> void:
	var rot := linked_player_controller.rotation
	rot.y -= linked_player_controller.input_mouse_turn.x * delta
	linked_player_controller.rotation = rot

func _set_head_rotation(delta: float) -> void:
	var hrot := linked_player_controller.head.rotation
	hrot.x -= linked_player_controller.input_mouse_turn.y * delta
	linked_player_controller.head.rotation = hrot
