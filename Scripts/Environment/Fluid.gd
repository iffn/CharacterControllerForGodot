extends Area3D

class_name Fluid

@export var _density: float = 1000

var density: float:
	get:
		return _density

func _on_body_entered(body: Node3D) -> void:
	var character := body as FirstPersonPlayerController
	if(character):
		character.enter_area(self)

func _on_body_exited(body: Node3D) -> void:
	var character := body as FirstPersonPlayerController
	if(character):
		character.exit_area(self)
