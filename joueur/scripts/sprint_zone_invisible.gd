extends Area3D

@export var zone_width: float = 10.0 :
	set(value):
		zone_width = value
		_update_zone_size()
		
@export var zone_length: float = 10.0 :
	set(value):
		zone_length = value
		_update_zone_size()

func _ready():
	_update_zone_size()

func _update_zone_size():
	# Mettre à jour uniquement la forme de collision
	if has_node("CollisionShape3D"):
		var box_shape = $CollisionShape3D.shape as BoxShape3D
		if box_shape:
			box_shape.size = Vector3(zone_width, 20.0, zone_length)

func _on_body_entered(body):
	if body.has_method("set_sprint_enabled"):
		body.set_sprint_enabled(true)

func _on_body_exited(body):
	if body.has_method("set_sprint_enabled"):
		body.set_sprint_enabled(false)
