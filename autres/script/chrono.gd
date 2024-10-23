extends Label

var elapsed_time = 0.0  # Temps écoulé depuis le début du jeu

func _process(delta: float) -> void:
	# Incrémenter le temps écoulé
	elapsed_time += delta
	
	# Calculer les minutes et les secondes
	var minutes = int(elapsed_time) / 60
	var seconds = int(elapsed_time) % 60
	
	# Afficher le chronomètre dans le label (format mm:ss)
	text = "%02d:%02d" % [minutes, seconds]
