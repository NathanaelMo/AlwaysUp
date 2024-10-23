extends StaticBody3D

@export var visible_time: float = 3.0  # Temps d'affichage en secondes
@export var hidden_time: float = 1.0   # Temps de disparition en secondes
@export var start_delay: float = 0.0   # Délai de démarrage en secondes

@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D
@onready var timer: Timer = $Timer

var is_visible: bool = true

func _ready():
	
	if not timer:
		print("ERROR: Timer node not found!")
		return
	
	timer.one_shot = true
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))
	
	if start_delay > 0:
		await get_tree().create_timer(start_delay).timeout

	_start_visible_cycle()

func _start_visible_cycle():
	is_visible = true
	_update_visibility()
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
