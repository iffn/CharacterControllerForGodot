using Godot;
using System;

public partial class FirstPersonPlayerController : CharacterBody3D
{
	[Export] public Node3D Head { get; protected set; }
	[Export] public double WalkSpeed { get; protected set; } = 5.0;
	[Export] public double RunSpeed { get; protected set; } = 10.0;
	[Export] public double JumpVelocity { get; protected set; } = 4.5;
	[Export] public float MouseSensitivity { get; protected set; } = 0.002f;

	[Export] MovementSystem defaultMovementSystem;

	public readonly double gravity = (double)ProjectSettings.GetSetting("physics/3d/default_gravity");

	// Existing properties:
	// FloorMaxAngle is already defined
	// IsOnFloor() is already defined

	// Overriding properties
	
	public new Vector3 GlobalPosition
	{
		get
		{
			return base.GlobalPosition;
		}
		set
		{
			base.GlobalPosition = value;
			// ToDo: Implement teleportation stuff if needed
		}
	}

	public new Vector3 Rotation
	{
		get
		{
			return base.Rotation;
		}
		set
		{
			base.Rotation = value;
		}
	}

	// New properties
	MovementSystem currentMovementSystem;

	public MovementSystem CurrentMovementSystem
	{
		set
		{
			currentMovementSystem.Disable();
			currentMovementSystem = value;
			currentMovementSystem.Setup(this);
			currentMovementSystem.Enable();
		}
		get
		{
			return currentMovementSystem;
		}
	}

	public Vector3 HeadRotation
	{
		get
		{
			return Head.Rotation;
		}
		set
		{
			Head.Rotation = value;
		}
	}

	public Vector2 RelativeHorizontalVelocityFwdRight
	{
		get
		{
			Vector3 vWorld = Velocity;
			Basis basis = GlobalTransform.Basis;
			Vector3 vLocal = basis.Inverse() * vWorld;
			return new Vector2(-vLocal.Z, vLocal.X);
		}
		set
		{
			// ToDo: Test with weird player rotations

			Vector3 vWorld = Velocity;

			Basis basis = GlobalTransform.Basis;
			Vector3 vLocal = basis.Inverse() * vWorld;

			vLocal.X = value.Y;   // right
			vLocal.Z = -value.X;  // forward

			// back to world space
			Vector3 newWorld = basis * vLocal;
			Velocity = new Vector3(newWorld.X, vWorld.Y, newWorld.Z);
		}
	}

	public double VerticalVelocity
	{
		get
		{
			return Velocity.Y;
		}
		set
		{
			Vector3 v = Velocity;
			v.Y = (float)value;
			Velocity = v;
		}
	}

	public Vector2 InputMouseTurn { get; protected set; } = Vector2.Zero;

	/*
	public double Heading
	{
		get
		{
			return Rotation.Y;
		}
		set
		{
			Vector3 newRotation = Rotation;
			newRotation.Y = (float)value;
			Rotation = newRotation;
		}
	}

	public double HeadPitch
	{
		get
		{
			return Head.Rotation.X;
		}
		set
		{
			value = Math.Clamp(value, -Math.PI * 0.5, Math.PI * 0.5);
			Vector3 newRotation = Head.Rotation;
			newRotation.X = (float)value;
			Head.Rotation = newRotation;
		}
	}
	*/

	public override void _Ready()
	{
		base._Ready();

		currentMovementSystem = defaultMovementSystem;
		currentMovementSystem.Setup(this);

		Input.MouseMode = Input.MouseModeEnum.Captured;
	}

	public override void _UnhandledInput(InputEvent @event)
	{
		if (@event is InputEventMouseMotion motion && Input.MouseMode == Input.MouseModeEnum.Captured)
		{
			float X = motion.Relative.X * MouseSensitivity;
			float Y = motion.Relative.Y * MouseSensitivity;
			InputMouseTurn = new Vector2((float)X, (float)Y);
		}

		// Unlock mouse when pressing Escape
		if (@event is InputEventKey key && key.Pressed && key.Keycode == Key.Escape)
		{
			Input.MouseMode = Input.MouseModeEnum.Visible;
		}
	}

	public override void _PhysicsProcess(double delta)
	{
		currentMovementSystem.PhysicsProcess(delta);
	}
}
