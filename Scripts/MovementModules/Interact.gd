extends MovementModule

class_name Interact

var collider := Object

func input_event(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var current_collider = collider
			if(current_collider):
				var interactible := current_collider as Interactible
				if(interactible):
					interactible.Interact()

func callable_physics_process(delta: float) -> void:
	var head_position_world := linked_player_controller.head_position_world
	var look_direction := linked_player_controller.look_direction_world
	var space: PhysicsDirectSpaceState3D = linked_player_controller.physics_space

	var query: PhysicsRayQueryParameters3D = PhysicsRayQueryParameters3D.create(
		head_position_world + look_direction * 0.5,
		head_position_world + look_direction * 100
	)
	
	query.collide_with_areas = true
	
	var hit: Dictionary = space.intersect_ray(query)
	
	if hit:
		var current_collider: Object = hit["collider"]
		if(current_collider):
			collider = current_collider
		else:
			collider = null
	else:
			collider = null
