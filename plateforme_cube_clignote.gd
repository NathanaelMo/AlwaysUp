extends StaticBody3D

var is_visible = true

func _ready():
	# Démarrer le Timer et connecter son signal "timeout"
	$Timer.connect("timeout", Callable(self, "_on_Timer_timeout"))  # Utilise Callable pour la connexion
	$Timer.start()

func _on_Timer_timeout():
	# Alterner entre visible et invisible
	is_visible = !is_visible
	$MeshInstance3D.visible = is_visible
	$CollisionShape3D.disabled = not is_visible  # Désactiver les collisions lorsque la plateforme est invisible
