using Godot;

public partial class SimpleFirstPersonPlayerController : CharacterBody3D
{
	[Export] public Node3D Head { get; set; }

	[Export] public float Speed = 5.0f;
	[Export] public float JumpVelocity = 4.5f;
	[Export] public float MouseSensitivity = 0.002f;

	private readonly float _gravity = (float)ProjectSettings.GetSetting("physics/3d/default_gravity");
	private float _yaw = 0.0f;
	private float _pitch = 0.0f;

	public override void _Ready()
	{
		Input.MouseMode = Input.MouseModeEnum.Captured;
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		// Mouse rotation
		if (@event is InputEventMouseMotion motion && Input.MouseMode == Input.MouseModeEnum.Captured)
		{
			_yaw -= motion.Relative.X * MouseSensitivity;
			_pitch -= motion.Relative.Y * MouseSensitivity;
			_pitch = Mathf.Clamp(_pitch, Mathf.DegToRad(-90f), Mathf.DegToRad(90f));

			var rot = Rotation;
			rot.Y = _yaw;
			Rotation = rot;

			if (Head != null)
			{
				var hrot = Head.Rotation;
				hrot.X = _pitch;
				Head.Rotation = hrot;
			}
		}

		// Unlock mouse when pressing Escape
		if (@event is InputEventKey key && key.Pressed && key.Keycode == Key.Escape)
		{
			Input.MouseMode = Input.MouseModeEnum.Visible;
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		var v = Velocity;

		// Horizontal velocity from movement inputs
		Vector3 inputDir = Vector3.Zero;
		inputDir.X = Input.GetActionStrength("move_right") - Input.GetActionStrength("move_left");
		inputDir.Z = Input.GetActionStrength("move_backward") - Input.GetActionStrength("move_forward");
		inputDir = inputDir.Normalized();

		var direction = (Transform.Basis * inputDir).Normalized();
		var horizontalVelocity = direction * Speed;
		v.X = horizontalVelocity.X;
		v.Z = horizontalVelocity.Z;

		// Vertical velocity from falling and jumping
		if (!IsOnFloor())
			v.Y -= _gravity * (float)delta;

		if (IsOnFloor() && Input.IsActionJustPressed("jump"))
			v.Y = JumpVelocity;

		// Applying velocity
		Velocity = v;

		// --- Sliding / slope handling via friction -> floor max angle ---
		if (IsOnFloor())
		{
			float mu = GetFloorFriction();
			float maxAngle = Mathf.Atan(mu);
			FloorMaxAngle = maxAngle;
		}

		MoveAndSlide();
	}

	private KinematicCollision3D? GetFloorCollision()
	{
		for (int i = 0; i < GetSlideCollisionCount(); i++)
		{
			var collision = GetSlideCollision(i);
			if (collision.GetNormal().Dot(Vector3.Up) > Mathf.Sin(Mathf.DegToRad(5.0f)))
				return collision;
		}
		return null;
	}

	private float GetFloorFriction()
	{
		var col = GetFloorCollision();
		if (col == null)
			return 1.0f;

		var collider = col.GetCollider();

		// PhysicsMaterialOverride exists on concrete body types (not on the abstract bases).
		if (collider is RigidBody3D rb && rb.PhysicsMaterialOverride != null)
			return rb.PhysicsMaterialOverride.Friction;

		if (collider is StaticBody3D sb && sb.PhysicsMaterialOverride != null)
			return sb.PhysicsMaterialOverride.Friction;

		// Fallback: check child CollisionShape3D -> Shape3D -> PhysicsMaterial
		/*
		if (collider is Node node)
		{
			foreach (var child in node.GetChildren())
			{
				if (child is CollisionShape3D cs && cs.Shape is { } shape && shape.PhysicsMaterial != null)
					return shape.PhysicsMaterial.Friction;
			}
		}
		*/

		return 1.0f;
	}
}
