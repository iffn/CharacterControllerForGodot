using Godot;
using System;

public partial class MovementModule : Node
{
    protected FirstPersonPlayerController linkedPlayerController;

    protected bool SetupRan { get; private set; } = false;

    public virtual void Setup(FirstPersonPlayerController linkedPlayerController)
    {
        this.linkedPlayerController = linkedPlayerController;
        SetupRan = true;
    }

    public virtual void Enable()
    {

    }

    public virtual void Disable()
    {

    }

    public virtual void PhysicsProcess(double delta)
    {

    }
}
