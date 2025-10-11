using Godot;
using System;
using System.Collections.Generic;

public partial class GeneralMovementSystem : MovementSystem
{
    [Export] MovementModule[] movementModulesInExecutionOrder;

    protected override MovementModule[] AllModulesWithoutNullCheckInExecutionOrder
    {
        get
        {
            return movementModulesInExecutionOrder;
        }
    }

    public override void Setup(FirstPersonPlayerController linkedPlayerController)
    {
        base.Setup(linkedPlayerController);
    }
}
