extends StaticBody3D

@export var speed: float = 15.0
@export var distance: float = 15.0
@export var direction: Vector3 = Vector3(1, 0, 0)

var start_position: Vector3
var target_position: Vector3
var moving_forward: bool = true
var material: StandardMaterial3D
var mesh_instance: MeshInstance3D

func _ready() -> void:
	# Attendre que le nœud soit complètement prêt
	await get_tree().process_frame
	
	# Obtenir la référence au MeshInstance3D
	mesh_instance = $MeshInstance3D
	if mesh_instance:
		material = mesh_instance.get_surface_override_material(0)
	
	# Initialiser les positions
	start_position = global_transform.origin
	target_position = start_position + direction * distance
	
	# Activer le traitement
	set_process(true)

func _process(delta: float) -> void:
	# Vérifier que mesh_instance et material sont valides
	if mesh_instance and material:
		if mesh_instance.get_surface_override_material(0) != material:
			mesh_instance.set_surface_override_material(0, material)
	
	if moving_forward:
		global_transform.origin += direction * speed * delta
		if global_transform.origin.distance_to(target_position) < 0.5:
			moving_forward = false
	else:
		global_transform.origin -= direction * speed * delta
		if global_transform.origin.distance_to(start_position) < 0.5:
			moving_forward = true
