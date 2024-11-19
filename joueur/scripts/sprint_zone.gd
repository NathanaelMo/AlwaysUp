extends Area3D

@export var zone_width: float = 10.0
@export var zone_length: float = 10.0

func _ready():
	# Configurer la forme de collision pour la zone
	var collision_shape = CollisionShape3D.new()
	var box_shape = BoxShape3D.new()
	box_shape.size = Vector3(zone_width, 2.0, zone_length)  # Hauteur fixe de 2 unités
	collision_shape.shape = box_shape
	add_child(collision_shape)
	
	# Créer un indicateur visuel de la zone
	var mesh_instance = MeshInstance3D.new()
	var box_mesh = BoxMesh.new()
	box_mesh.size = Vector3(zone_width, 0.1, zone_length)  # Fine épaisseur pour visualisation
	var material = StandardMaterial3D.new()
	material.transparency = BaseMaterial3D.TRANSPARENCY_ALPHA
	material.albedo_color = Color(0.0, 1.0, 0.0, 0.3)  # Vert semi-transparent
	mesh_instance.mesh = box_mesh
	mesh_instance.material_override = material
	add_child(mesh_instance)
	
	# Connecter les signaux
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body):
	if body.has_method("set_sprint_enabled"):
		body.set_sprint_enabled(true)

func _on_body_exited(body):
	if body.has_method("set_sprint_enabled"):
		body.set_sprint_enabled(false)
