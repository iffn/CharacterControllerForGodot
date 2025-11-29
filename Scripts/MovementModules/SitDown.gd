extends MovementModule

class_name SitDown

@export var interaction_text : Label
@export var sitting_system : MovementSystem
@export var sit_movement : Sit
@export_flags_3d_physics var ray_collision_mask: int = 1

var seat : Seat

func enable() -> void:
	if(seat):
		seat.activation_state = Seat.Activations.IDLE
	seat = null
	set_display_text("")

func disable() -> void:
	if(seat):
		seat.activation_state = Seat.Activations.IDLE
	seat = null
	set_display_text("")

func set_display_text(new_text : String):
	interaction_text.text = new_text

func input_event(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if(seat):
				sit_movement.current_seat = seat
				linked_player_controller.current_movement_system = sitting_system

func callable_physics_process(delta: float) -> void:
	var head_position_world := linked_player_controller.head_position_world
	var look_direction := linked_player_controller.look_direction_world
	var space: PhysicsDirectSpaceState3D = linked_player_controller.physics_space

	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(
		head_position_world + look_direction * 0.5,
		head_position_world + look_direction * 100
	)
	
	query.collision_mask = ray_collision_mask
	query.collide_with_areas = true
	
	var hit: Dictionary = space.intersect_ray(query)
	
	if hit:
		var current_collider: Object = hit["collider"]
		if(current_collider):
			var new_seat := current_collider as Seat
			if(new_seat != seat):
				if(seat):
					seat.activation_state = Seat.Activations.IDLE
				if(new_seat):
					set_display_text(new_seat.interaction_text)
					new_seat.activation_state = new_seat.Activations.ACTIVE
				else:
					set_display_text("")
				seat = new_seat
		else:
			if(seat):
				seat.activation_state = Seat.Activations.IDLE
			seat = null
			set_display_text("")
	else:
		if(seat):
				seat.activation_state = Seat.Activations.IDLE
		seat = null
		set_display_text("")
