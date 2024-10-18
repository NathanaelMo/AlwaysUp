extends StaticBody3D

# Points de départ et d'arrivée sur l'axe Z
@export var point_a: float = 10.0
@export var point_b: float = 30.0
@export var vitesse: float = 5.0

var direction = 1

# Référence au personnage qui est en collision
var personnage_en_contact: CharacterBody3D = null

func _process(delta):
	# Obtenir la position actuelle
	var position_actuelle = position.z
	
	# Calculer le déplacement pour ce frame
	var deplacement = vitesse * direction * delta
	
	# Déplacer le cube
	position.z += deplacement
	
	# Si un personnage est en contact, appliquer le même déplacement
	if personnage_en_contact != null:
		personnage_en_contact.position.z += deplacement
	
	# Vérifier si on a atteint un des points
	if direction == 1 and position.z >= point_b:
		direction = -1
	elif direction == -1 and position.z <= point_a:
		direction = 1

# Cette fonction sera appelée quand quelque chose entre en collision avec le cube
func _on_body_entered(body):
	if body.is_in_group("joueur"):  # Assurez-vous que votre personnage est dans le groupe "joueur"
		personnage_en_contact = body

# Cette fonction sera appelée quand quelque chose quitte la collision avec le cube
func _on_body_exited(body):
	if body == personnage_en_contact:
		personnage_en_contact = null
