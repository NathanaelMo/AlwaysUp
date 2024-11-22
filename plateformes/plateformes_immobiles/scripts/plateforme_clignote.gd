extends StaticBody3D

@export var visible_time: float = 3.0 # Temps d'affichage en secondes
@export var hidden_time: float = 1.0 # Temps de disparition en secondes
@export var start_delay: float = 0.0 # Délai de démarrage en secondes
@export var warning_time: float = 1.0 # Temps d'avertissement avant disparition

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var timer: Timer = $Timer

var is_visible: bool = true
var original_color: Color = Color(0, 1, 0) # Vert
var warning_color: Color = Color(1, 0, 0) # Rouge
var current_material: StandardMaterial3D

func _ready():
	if not timer:
		print("ERROR: Timer node not found!")
		return
	
	current_material = mesh_instance.get_surface_override_material(0)
	if current_material:
		current_material = current_material.duplicate()
		mesh_instance.set_surface_override_material(0, current_material)
		original_color = current_material.albedo_color
	
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	
	if start_delay > 0:
		await get_tree().create_timer(start_delay).timeout

	_start_visible_cycle()

func _process(delta):
	if is_visible and timer.time_left <= warning_time:
		var t = 1.0 - (timer.time_left / warning_time)
		var warning_intensity = min(t, 1.0)
		_update_color(warning_intensity)

func _update_color(warning_intensity: float):
	if current_material:
		current_material.albedo_color = original_color.lerp(warning_color, warning_intensity)

func _start_visible_cycle():
	is_visible = true
	_update_visibility()
	if current_material:
		current_material.albedo_color = original_color
	timer.start(visible_time)

func _start_hidden_cycle():
	is_visible = false
	_update_visibility()
	timer.start(hidden_time)

func _update_visibility():
	if mesh_instance:
		mesh_instance.visible = is_visible
	else:
		print("ERROR: MeshInstance3D not found!")
	
	if collision_shape:
		collision_shape.disabled = !is_visible
	else:
		print("ERROR: CollisionShape3D not found!")

func _on_Timer_timeout():
	if is_visible:
		_start_hidden_cycle()
	else:
		_start_visible_cycle()
