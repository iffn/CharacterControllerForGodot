extends MovementModule

class_name Slide

func _physics_process(delta: float) -> void:
	# Friction formulas:
	# ------------------
	# α = acos(Ny)
	#   = atan(µ)
	
	# Ny = cos(α)
  	#    = cos(atan(µ))
		
	# µ = tan(α)
	#   = tan(acos(Ny)
		
	# α = slope angle
	# Ny = Normalized normal y
	# µ = Friction coefficient
	
	var μ := get_floor_friction()
	var max_angle_rad = atan(μ)
	
	linked_player_controller.floor_max_angle = max_angle_rad

func get_floor_friction() -> float:
	var collision : KinematicCollision3D
	var col := linked_player_controller.floor_colliders
	
	for i in range(col.size()):
		collision = col[i]
		if collision.get_normal().dot(Vector3.UP) > sin(deg_to_rad(5.0)):
			break
	
	if collision == null:
		return 1.0

	var collider := collision.get_collider()
	if collider is PhysicsBody3D and collider.physics_material_override:
		return collider.physics_material_override.friction

	# Check child CollisionShapes (in case material is defined there)
	# Throws error...
	#if collider is Node3D:
		#for child in collider.get_children():
			#if child is CollisionShape3D and child.physics_material_override:
				#return child.physics_material_override.friction

	return 1.0
