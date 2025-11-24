extends MovementModule

class_name Interact

@export var interaction_text : Label

var interactible : Interactible

func set_display_text(new_text : String):
	interaction_text.text = new_text

func input_event(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if(interactible):
				interactible.Interact()

func enable() -> void:
	interactible = null
	set_display_text("")

func disable() -> void:
	interactible = null
	set_display_text("")

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
			var new_interactible := current_collider as Interactible
			if(new_interactible != interactible):
				if(new_interactible):
					set_display_text(new_interactible.interaction_text)
				else:
					set_display_text("")
				interactible = new_interactible
		else:
			set_display_text("")
	else:
		set_display_text("")
