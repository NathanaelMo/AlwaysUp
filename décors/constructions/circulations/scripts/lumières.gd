# lumières.gd
extends Node3D

var warning_lights = []
var warning_bulbs = []
var time_elapsed = 0.0
const BLINK_INTERVAL = 1.0

func _ready():
	await get_tree().create_timer(0.1).timeout
	
	# Récupérer à la fois les lumières et leurs ampoules
	warning_lights = $RoofLights.get_children()
	for light in warning_lights:
		if light.has_node("WarningBulb"):
			warning_bulbs.append(light.get_node("WarningBulb"))
			
	if warning_lights.size() > 0:
		print("Lumières trouvées: ", warning_lights.size())
	else:
		print("Aucune lumière trouvée!")

func _process(delta):
	if warning_lights.size() > 0:
		time_elapsed += delta
		if time_elapsed >= BLINK_INTERVAL:
			time_elapsed = 0.0
			for i in range(warning_lights.size()):
				var light = warning_lights[i]
				var bulb = warning_bulbs[i]
				
				if light.light_energy == 0.0:
					# Allumer
					light.light_energy = 16.0
					if bulb:
						var material = bulb.get_surface_override_material(0)
						if material:
							material.emission = Color(1, 0, 0, 1)
							material.emission_energy_multiplier = 2.0
				else:
					# Éteindre
					light.light_energy = 0.0
					if bulb:
						var material = bulb.get_surface_override_material(0)
						if material:
							material.emission = Color(0.2, 0, 0, 1)
							material.emission_energy_multiplier = 0.5
