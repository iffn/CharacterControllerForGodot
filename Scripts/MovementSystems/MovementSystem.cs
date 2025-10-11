using Godot;
using System;
using System.Collections.Generic;

public abstract partial class MovementSystem : Node
{
    protected FirstPersonPlayerController linkedPlayerController;

    protected abstract MovementModule[] AllModulesWithoutNullCheckInExecutionOrder { get; }

    List<MovementModule> allValidModules;

    public virtual void Setup(FirstPersonPlayerController linkedPlayerController)
    {
        this.linkedPlayerController = linkedPlayerController;

        allValidModules = new List<MovementModule>();


        for (int i = 0; i < AllModulesWithoutNullCheckInExecutionOrder.Length; i++)
        {
            if (AllModulesWithoutNullCheckInExecutionOrder[i] == null)
            {
                GD.Print("Warning: A movement module in NormalMovement is null and will be removed.");
            }
            else
            {
                allValidModules.Add(AllModulesWithoutNullCheckInExecutionOrder[i]);
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
