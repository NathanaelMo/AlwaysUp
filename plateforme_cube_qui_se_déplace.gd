extends StaticBody3D

@export var speed = 2.0  # Vitesse de la plateforme
@export var distance = 15.0  # Distance que la plateforme parcourt
@export var direction = Vector3(0, 0, 1)  # Mouvement le long de l'axe Z (changer si nécessaire)

var start_position = Vector3()  # Position de départ de la plateforme
var target_position = Vector3()  # Position cible
var moving_forward = true  # Contrôle la direction du mouvement
var velocity = Vector3.ZERO  # Vitesse actuelle de la plateforme

func _ready():
    start_position = global_transform.origin
    target_position = start_position + direction * distance
    set_process(true)

func _process(delta):
    var previous_position = global_transform.origin
    
    if moving_forward:
        global_transform.origin += direction * speed * delta
        if global_transform.origin.distance_to(target_position) <= 0.1:
            moving_forward = false
    else:
        global_transform.origin -= direction * speed * delta
        if global_transform.origin.distance_to(start_position) <= 0.1:
            moving_forward = true
    
    velocity = (global_transform.origin - previous_position) / delta
    set_transform(global_transform)

func get_platform_velocity():
    return velocity