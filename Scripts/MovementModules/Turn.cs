using Godot;
using System;

public partial class Turn : MovementModule
{
    public override void PhysicsProcess(double delta)
    {
        base.PhysicsProcess(delta);

        SetBodyRotation();
        SetHeadRotation();
    }

    void SetBodyRotation()
    {
        Vector3 newRotation = linkedPlayerController.Rotation;
        newRotation.Y -= linkedPlayerController.InputMouseTurn.X;
        linkedPlayerController.Rotation = newRotation;
    }

    void SetHeadRotation()
    {
        Vector3 newRotation = linkedPlayerController.HeadRotation;
        newRotation.X -= linkedPlayerController.InputMouseTurn.Y;
        linkedPlayerController.HeadRotation = newRotation;
    }
}
