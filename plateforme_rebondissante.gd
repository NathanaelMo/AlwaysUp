extends Area3D

@export var bounce_force : float = 30.0

func _on_body_entered(body):
	if body is CharacterBody3D:
		body.velocity.y = bounce_force
