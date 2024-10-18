extends Label

@export var player: NodePath

var record_height = 0.0  # Stocker le record de hauteur atteint

func _process(delta: float) -> void:
	var player_node = get_node_or_null(player)
	if player_node:
		var player_height = round(player_node.global_transform.origin.y)
		
		# Comparer la hauteur actuelle avec le record et mettre à jour si nécessaire
		if player_height > record_height:
			record_height = player_height
		
		# Afficher la hauteur actuelle et le record
		text = "Hauteur: %d m\nRecord: %d m" % [player_height, record_height]
	else:
		print("Player node not found!")
