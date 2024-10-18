extends StaticBody3D

@export var speed = 15.0  # Vitesse de la plateforme
@export var distance = 15.0  # Distance que la plateforme parcourt
@export var direction = Vector3(1, 0, 0)  # Mouvement le long de l'axe Z (changer si nécessaire)

var start_position = Vector3()  # Position de départ de la plateforme
var target_position = Vector3()  # Position cible
var moving_forward = true  # Contrôle la direction du mouvement

func _ready():
	start_position = global_transform.origin
	target_position = start_position + direction * distance
	set_process(true)

func _process(delta):
	if moving_forward:
		# Déplacer vers la position cible
		global_transform.origin += direction * speed * delta
		# Vérifier si la plateforme a atteint ou dépassé la position cible
		if global_transform.origin.distance_to(target_position) < 0.5:
			moving_forward = false  # Changer de direction
	else:
		# Revenir à la position de départ
		global_transform.origin -= direction * speed * delta
		# Vérifier si la plateforme est revenue à la position initiale
		if global_transform.origin.distance_to(start_position) < 0.5:
			moving_forward = true  # Repartir vers l'avant
	
	# Appliquer la nouvelle position à la plateforme
	set_transform(global_transform)
