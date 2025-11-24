extends MovementModule

class_name Sit

@export var _crouch_height_factor: float = 0.5
@export var _stand_up_system : MovementSystem

var _current_seat : Seat

var current_seat : Seat:
	set(value):
		if(_current_seat):
			_current_seat.occupied_localy = false;
		_current_seat = value
		if(_current_seat):
			_current_seat.occupied_localy = true;
	get:
		return _current_seat

func enable() -> void:
	super()
	if(current_seat == null):
		print("cannot sit down, no seat assigned")
		linked_player_controller.current_movement_system = _stand_up_system
	else:
		current_seat.occupied_localy = true
		linked_player_controller.reparent_visual_body_if_assigned(current_seat.sitting_position)
		linked_player_controller.height_multiplier = _crouch_height_factor

func disable() -> void:
	super()
	linked_player_controller.height_multiplier = 1.0
	if(current_seat != null):
		current_seat.occupied_localy = false
		linked_player_controller.reparent_visual_body_if_assigned(null)

func get_out() -> void:
	current_seat = null
	linked_player_controller.reparent_visual_body_if_assigned(null)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump"):
		get_out()
		linked_player_controller.current_movement_system = _stand_up_system
