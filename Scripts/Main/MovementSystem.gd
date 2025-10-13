# MovementSystem.gd
extends Node
class_name MovementSystem

@export var test: String = "blue"
@export var movement_modules_in_execution_order: Array[MovementModule] = []

var linked_player_controller: FirstPersonPlayerController
var _all_valid_modules: Array[MovementModule] = []

func setup(player: FirstPersonPlayerController) -> void:
	linked_player_controller = player
	_all_valid_modules.clear()

	for i in movement_modules_in_execution_order.size():
		var module := movement_modules_in_execution_order[i]
		if module == null:
			push_warning("A movement module in MovementSystem is null and will be removed.")
		else:
			_all_valid_modules.append(module)

	for module in _all_valid_modules:
		module.setup(linked_player_controller)

func enable() -> void:
	# override in subclasses if needed
	pass

func disable() -> void:
	# override in subclasses if needed
	pass

func callable_process(delta: float) -> void:
	for module in _all_valid_modules:
		module.callable_process(delta)

func callable_physics_process(delta: float) -> void:
	for module in _all_valid_modules:
		module.callable_physics_process(delta)
