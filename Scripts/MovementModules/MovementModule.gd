# MovementModule.gd
extends Node
class_name MovementModule

var linked_player_controller: FirstPersonPlayerController

var _setup_ran := false
var setup_ran: bool:
	get: return _setup_ran

func setup(player: FirstPersonPlayerController) -> void:
	linked_player_controller = player
	_setup_ran = true

func input_event(event: InputEvent) -> void:
	pass

func enable() -> void:
	pass

func disable() -> void:
	pass

func _ready() -> void:
	if !_setup_ran:
		set_process(false)
		set_physics_process(false)

func callable_process(delta: float) -> void:
	pass

func callable_physics_process(delta: float) -> void:
	pass
