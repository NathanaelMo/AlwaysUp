extends StaticBody3D

@export_category("Mouvement")
@export var speed: float = 10.0  # Vitesse de la plateforme
@export var distance: float = 20.0  # Distance que la plateforme parcourt
@export var direction: Vector3 = Vector3(0, 1, 0)  # Direction du mouvement
@export var delay_time: float = 2.0  # Temps d'attente aux extremites
@export var starts_up: bool = true  # True pour commencer en montant, False pour descendre

var start_position: Vector3  # Position de départ de la plateforme
var target_position: Vector3  # Position cible
var moving_forward: bool  # Controle la direction du mouvement
var is_waiting: bool = false  # Indique si la plateforme est en attente
var timer: Timer  # Timer pour gerer les délais

func _ready() -> void:
	# Initialiser les positions
	start_position = global_transform.origin
	
	# Définir la direction initiale et la position cible en fonction de starts_up
	moving_forward = starts_up
	if starts_up:
		target_position = start_position + direction * distance
	else:
		# Si on commence en descendant, la cible est en-dessous
		target_position = start_position - direction * distance
	
	# Créer et configurer le timer
	timer = Timer.new()
	add_child(timer)
	timer.one_shot = true
	timer.timeout.connect(_on_timer_timeout)
	
	set_process(true)

func _process(delta: float) -> void:
	if is_waiting:
		return
		
	if moving_forward:
		global_transform.origin += direction * speed * delta
		if global_transform.origin.distance_to(start_position + direction * distance) <= 0.1:
			is_waiting = true
			timer.start(delay_time)
			moving_forward = false
	else:
		global_transform.origin -= direction * speed * delta
		if global_transform.origin.distance_to(start_position - direction * distance) <= 0.1:
			is_waiting = true
			timer.start(delay_time)
			moving_forward = true

func _on_timer_timeout() -> void:
	is_waiting = false
