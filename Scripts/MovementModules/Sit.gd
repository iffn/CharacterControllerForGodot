extends MovementModule

class_name Sit

@export var _crouch_height_factor: float = 0.5
@export var _stand_up_system : MovementSystem

var current_seat : Seat

func enable() -> void:
	super()
	if(current_seat == null):
		print("cannot sit down, no seat assigned")
		linked_player_controller.current_movement_system = _stand_up_system
	else:
		linked_player_controller.reparent_visual_body_if_assigned(current_seat.sitting_position)
		linked_player_controller.height_multiplier = _crouch_height_factor

func disable() -> void:
	super()
	linked_player_controller.height_multiplier = 1.0
	if(current_seat != null):
		linked_player_controller.reparent_visual_body_if_assigned(null)

func get_out() -> void:
	current_seat = null
	linked_player_controller.reparent_visual_body_if_assigned(null)

func callable_process(delta: float) -> void:
	super(delta)
	if(Input.is_action_just_pressed("jump")):
		get_out()
		linked_player_controller.current_movement_system = _stand_up_system
