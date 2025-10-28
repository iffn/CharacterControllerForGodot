extends Area3D

class_name Fluid

@export var _density: float = 1000

var density: float:
	get:
		return _density

func in_fluid(sample_point_world: Vector3) -> bool:
	var collision_shape := get_child(0) as CollisionShape3D
	if not collision_shape:
		return false
	# Get the shape (e.g., BoxShape3D)
	var shape := collision_shape.shape
	if not shape:
		return false
	# Convert the position to the Area3D's local space
	var local_position := to_local(sample_point_world)
	# Check if the local position is inside the shape
	if shape is BoxShape3D:
		var box_shape = shape as BoxShape3D
		var extents = box_shape.size * 0.5  # BoxShape3D uses full size, not half-extents
		return (
			local_position.x >= -extents.x && local_position.x <= extents.x &&
			local_position.y >= -extents.y && local_position.y <= extents.y &&
			local_position.z >= -extents.z && local_position.z <= extents.z
		)
	else:
		return false

func _on_body_entered(body: Node3D) -> void:
	var character := body as FirstPersonPlayerController
	if(character):
		character.enter_area(self)

func _on_body_exited(body: Node3D) -> void:
	var character := body as FirstPersonPlayerController
	if(character):
		character.exit_area(self)
