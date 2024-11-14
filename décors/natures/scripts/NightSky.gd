@tool
extends Node3D

var moon_instance: Node3D

func _ready():
	create_moon()

func create_moon():
	moon_instance = Node3D.new()
	moon_instance.name = "LuneEtLumiere"
	add_child(moon_instance)
	
	var moon_light = DirectionalLight3D.new()
	moon_light.name = "MoonLight"
	moon_light.light_color = Color(0.709804, 0.839216, 1, 0.8)
	moon_light.light_energy = 0.6  # Réduit pour un éclairage plus doux
	moon_light.light_volumetric_fog_energy = 0.2
	moon_light.shadow_enabled = true
	moon_light.shadow_bias = 0.1
	moon_light.shadow_normal_bias = 1.0
	
	# Fixer la rotation de la lumière pour un éclairage constant
	moon_light.rotation_degrees = Vector3(-60, 45, 0)  # Angle fixe
	moon_instance.add_child(moon_light)
	
	# Positionner l'ensemble lune + lumière très haut
	moon_instance.global_position = Vector3(0, 2000, -1000)
	
	# Créer la mesh de la lune
	var moon_mesh = SphereMesh.new()
	moon_mesh.radius = 50.0
	moon_mesh.height = 100.0
	moon_mesh.radial_segments = 32
	moon_mesh.rings = 16
	
	# Créer le matériau de la lune
	var moon_material = StandardMaterial3D.new()
	moon_material.albedo_color = Color(0.913725, 0.913725, 0.8, 1)
	moon_material.metallic = 0.1
	moon_material.roughness = 0.8
	moon_material.emission_enabled = true
	moon_material.emission = Color(0.913725, 0.913725, 0.8, 1)
	moon_material.emission_energy_multiplier = 0.8
	moon_material.rim_enabled = true
	moon_material.rim = 0.2
	moon_material.rim_tint = 0.5
	
	# Créer l'instance de la lune
	var moon = MeshInstance3D.new()
	moon.name = "Moon"
	moon.mesh = moon_mesh
	moon.set_surface_override_material(0, moon_material)
	moon_light.add_child(moon)
	
	# Positionner la mesh de la lune par rapport à sa lumière
	moon.transform.origin = Vector3(0, 0, -500)
	moon.transform.basis = Basis(Vector3(0.99953, 0.00819409, 0.0295323),
							   Vector3(-0.00767016, 0.999811, -0.0178114),
							   Vector3(-0.0296727, 0.0175765, 0.999404))
	
	# Ajouter le halo de la lune
	var moon_glow = OmniLight3D.new()
	moon_glow.name = "MoonGlow"
	moon_glow.light_color = Color(0.709804, 0.839216, 1, 1)
	moon_glow.light_energy = 15.0
	moon_glow.omni_range = 400.0
	moon_glow.omni_attenuation = 1.5
	moon.add_child(moon_glow)

# Supprimé le _process pour que la lune reste fixe
