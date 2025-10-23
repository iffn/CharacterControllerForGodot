extends MovementModule

class_name Swim

@export var linked_swim_detector: SwimDetector
@export var swim_normal_speed: float = 3
@export var swim_fast_speed: float = 5

func callable_physics_process(delta: float) -> void:
	var head_position_world := linked_player_controller.head_position_world
	
	var head_in_water := linked_swim_detector.in_fluid(head_position_world)
	
	swim(head_in_water)

func swim(head_in_water: bool):
	# Get input
	var input2D: Vector2 = linked_player_controller.input_move_direction_fwd_right
	
	var vertical_input := 0
	
	if(linked_player_controller.input_jump_pressed_or_held):
		vertical_input += 1
	
	if(Input.is_action_pressed("crouch")):
		vertical_input -= 1
	
	var input := Vector3(
		input2D.x,
		vertical_input,
		input2D.y
	)
	
	# Determine forward speed. Only sprint when going forward,
	var forward_speed: float
	
	if(input2D.x > 0):
		forward_speed = lerp(
			swim_normal_speed,
			swim_fast_speed,
			linked_player_controller.input_sprint
			)
	else:
		forward_speed = linked_player_controller.walk_speed
	
	# Determine and apply new velocity.
	var new_velocity := Vector3(
		forward_speed,
		swim_normal_speed,
		swim_normal_speed
	)
	
	new_velocity *= input.normalized() # Prevent angeled walking being faster
	
	var velocity_body := linked_player_controller.convert_from_head_to_body(new_velocity)
	
	linked_player_controller.relative_horizontal_velocity_fwd_right = Vector2(
		velocity_body.x, velocity_body.z
	)
	
	if(head_in_water || velocity_body.y < 0):
		linked_player_controller.add_vertical_velocity(velocity_body.y)
