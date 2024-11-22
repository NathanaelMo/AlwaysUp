extends StaticBody3D

@export_category("Mouvement")
@export var speed: float = 10.0 # Vitesse de la plateforme
@export var distance: float = 20.0 # Distance que la plateforme parcourt
@export var direction: Vector3 = Vector3(0, 1, 0) # Direction du mouvement
@export var delay_time: float = 2.0 # Temps d'attente aux extremites
@export var starts_up: bool = true # True pour commencer en montant, False pour descendre

var start_position: Vector3 # Position de départ de la plateforme
var moving_up: bool # Contrôle si la plateforme monte ou descend
var is_waiting: bool = false # Indique si la plateforme est en attente
var timer: Timer # Timer pour gérer les délais
var velocity = Vector3.ZERO # Vitesse actuelle de la plateforme

func _ready() -> void:
    # Sauvegarder la position initiale
    start_position = global_position
    
    # Initialiser la direction du mouvement
    moving_up = starts_up
    
    # Créer et configurer le timer
    timer = Timer.new()
    add_child(timer)
    timer.one_shot = true
    timer.timeout.connect(_on_timer_timeout)

func _process(delta: float) -> void:
    if is_waiting:
        velocity = Vector3.ZERO
        return
    
    var previous_position = global_position
    var current_height = global_position.y - start_position.y
    
    if moving_up:
        if current_height < distance:
            global_position += direction * speed * delta
        else:
            is_waiting = true
            timer.start(delay_time)
            moving_up = false
    else:
        if current_height > 0:
            global_position -= direction * speed * delta
        else:
            # S'assurer que la plateforme ne descend pas en dessous de sa position initiale
            global_position.y = start_position.y
            is_waiting = true
            timer.start(delay_time)
            moving_up = true
    
    # Calculer la vélocité actuelle
    velocity = (global_position - previous_position) / delta

func _on_timer_timeout() -> void:
    is_waiting = false

# Fonction pour obtenir la vélocité de la plateforme
func get_platform_velocity():
    return velocity