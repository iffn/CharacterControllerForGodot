using Godot;
using System;
using System.Collections.Generic;

public partial class NormalMovement : MovementSystem
{
    [Export] Turn turnModule;

    protected override MovementModule[] AllModulesWithoutNullCheckInExecutionOrder
    {
        get
        {
            return [
                turnModule
            ];
        }
    }

    public override void Setup(FirstPersonPlayerController linkedPlayerController)
    {
        base.Setup(linkedPlayerController);
    }
}
