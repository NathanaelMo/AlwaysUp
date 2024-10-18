extends StaticBody3D

@export var speed = 3.0  # Vitesse de la plateforme
@export var distance = 15.0  # Distance que la plateforme parcourt
@export var direction = Vector3(0, 1, 0)  # Mouvement le long de l'axe X (changer si nécessaire)

var start_position = Vector3()  # Position de départ de la plateforme
var target_position = Vector3()  # Position cible
var moving_forward = true  # Contrôle la direction du mouvement

func _ready():
	start_position = global_transform.origin
	target_position = start_position + direction * distance
	set_process(true)

func _process(delta):
	if moving_forward:
		global_transform.origin += direction * speed * delta
		if global_transform.origin.distance_to(target_position) <= 0.1:
			moving_forward = false
	else:
		global_transform.origin -= direction * speed * delta
		if global_transform.origin.distance_to(start_position) <= 0.1:
			moving_forward = true
	set_transform(global_transform)
