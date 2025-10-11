using Godot;
using System;
using System.Collections.Generic;

public partial class MovementSystem : Node
{
    [Export] MovementModule[] movementModulesInExecutionOrder;

    protected FirstPersonPlayerController linkedPlayerController;

    List<MovementModule> allValidModules;

    public virtual void Setup(FirstPersonPlayerController linkedPlayerController)
    {
        this.linkedPlayerController = linkedPlayerController;

        allValidModules = new List<MovementModule>();


        for (int i = 0; i < movementModulesInExecutionOrder.Length; i++)
        {
            if (movementModulesInExecutionOrder[i] == null)
            {
                GD.Print("Warning: A movement module in NormalMovement is null and will be removed.");
            }
            else
            {
                allValidModules.Add(movementModulesInExecutionOrder[i]);
            }
        }

        foreach (MovementModule module in allValidModules)
        {
            module.Setup(linkedPlayerController);
        }
    }

    public virtual void Enable()
    {

    }

    public virtual void Disable()
    {

    }

    public void PhysicsProcess(double delta)
    {
        foreach (MovementModule module in allValidModules)
        {
            module.PhysicsProcess(delta);
        }
    }
}
