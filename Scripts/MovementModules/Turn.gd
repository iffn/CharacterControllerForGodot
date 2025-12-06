extends MovementModule
class_name Turn

func input_event(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		var mm := event as InputEventMouseMotion
		var x := mm.relative.x * linked_player_controller.mouse_sensitivity
		var y := mm.relative.y * linked_player_controller.mouse_sensitivity
		var _input_mouse_turn = Vector2(x, y)
		
		var rot := linked_player_controller.body_visual_rotation_relative
		rot.y -= x
		linked_player_controller.body_visual_rotation_relative = rot
		
		var hrot := linked_player_controller.head_rotation
		hrot.x -= y
		linked_player_controller.head_rotation = hrot
