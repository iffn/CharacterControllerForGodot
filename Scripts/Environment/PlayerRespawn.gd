extends Node

@export var player : FirstPersonPlayerController
@export var control_indicator : Label

var spawn_position : Vector3
var spawn_rotation : Vector3

func save_spawn_location():
	spawn_position = player.global_position
	spawn_rotation = player.global_rotation

func respawn():
	player.global_position = spawn_position
	player.global_rotation = spawn_rotation

func _ready() -> void:
	save_spawn_location()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("respawn"):
		respawn()
	elif event.is_action_pressed("toggle_message"):
		control_indicator.visible = !control_indicator.visible
