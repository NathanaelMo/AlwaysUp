@tool
extends Node3D

@export var star_count: int = 2000
@export var sky_radius: float = 2000.0
@export var min_height: float = 500.0
@export var moon_distance: float = 1000.0
@export var moon_size: float = 50.0

var star_material = preload("res://addons/starlight/StarMaterial.tres")
var star_mesh: MultiMesh
var star_instance: MultiMeshInstance3D
var moon_instance: Node3D

func _ready():
	generate_night_sky()
	create_moon()

func generate_night_sky():
	star_mesh = MultiMesh.new()
	star_mesh.transform_format = MultiMesh.TRANSFORM_3D
	star_mesh.use_colors = true
	star_mesh.use_custom_data = true
	
	var quad = QuadMesh.new()
	quad.size = Vector2(1, 1)
	quad.material = star_material
	star_mesh.mesh = quad
	
	star_mesh.instance_count = star_count
	
	# Créer le MultiMeshInstance3D en premier
	star_instance = MultiMeshInstance3D.new()
	add_child(star_instance)
	
	# Configurer le rendu des étoiles
	star_instance.cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_OFF
	star_instance.gi_mode = GeometryInstance3D.GI_MODE_DISABLED
	
	var rng = RandomNumberGenerator.new()
	rng.seed = 12345
	
	for i in star_count:
		var theta = rng.randf() * PI * 2
		var phi = rng.randf() * PI / 2

		var x = sky_radius * cos(theta) * sin(phi)
		var y = sky_radius * cos(phi) + min_height
		var z = sky_radius * sin(theta) * sin(phi)

		var star_transform = Transform3D()
		star_transform.origin = Vector3(x, y, z)

		var temp = rng.randf_range(3000, 12000)
		var color = blackbody_to_rgb(temp)
		var luminosity = rng.randf_range(0.5, 4.0)

		var transform = Transform3D()
		transform.origin = Vector3(x, y, z)
		transform.basis = transform.basis.scaled(Vector3(3, 3, 3))  # Augmenter la taille

		star_mesh.set_instance_transform(i, transform)

		star_mesh.set_instance_transform(i, star_transform)
		star_mesh.set_instance_color(i, color)
		star_mesh.set_instance_custom_data(i, Color(luminosity, 0, 0, 1))

	star_instance.multimesh = star_mesh

func blackbody_to_rgb(kelvin: float) -> Color:
	var temp = kelvin / 100.0

	var red = 1.0
	var green = 0.0
	var blue = 0.0

	if temp > 66.0:
		red = 1.0

	if temp <= 66.0:
		green = clamp(0.39008157876901960784 * log(temp) - 0.63184144378862745098, 0, 1)
	else:
		green = clamp(1.29293618606274509804 * pow(temp - 60, -0.1332047592), 0, 1)

	if temp >= 66.0:
		blue = 1.0
	elif temp <= 19.0:
		blue = 0.0
	else:
		blue = clamp(0.54320678911019607843 * log(temp - 10) - 1.19625408914, 0, 1)
	
	return Color(red, green, blue)

func create_moon():
	# Créer le nœud parent pour la lune et sa lumière
	moon_instance = Node3D.new()
	moon_instance.name = "LuneEtLumiere"
	add_child(moon_instance)
	
	# Créer la lumière directionnelle de la lune
	var moon_light = DirectionalLight3D.new()
	moon_light.name = "MoonLight"
	moon_light.light_color = Color(0.709804, 0.839216, 1, 1)
	moon_light.light_energy = 0.7
	moon_light.light_volumetric_fog_energy = 0.2
	moon_light.shadow_enabled = true
	moon_light.shadow_blur = 2.0
	moon_instance.add_child(moon_light)
	
	# Positionner la lumière
	moon_light.transform.basis = Basis(Vector3(0.866025, -0.482963, 0.12941),
										Vector3(0, 0.258819, 0.965926),
										Vector3(-0.5, -0.836516, 0.224144))

	# Créer la mesh de la lune
	var moon_mesh = SphereMesh.new()
	moon_mesh.radius = moon_size
	moon_mesh.height = moon_size * 2
	moon_mesh.radial_segments = 32
	moon_mesh.rings = 16

	# Créer le matériau de la lune
	var moon_material = StandardMaterial3D.new()
	moon_material.albedo_color = Color(0.913725, 0.913725, 0.8, 1)
	moon_material.metallic = 0.1
	moon_material.roughness = 0.8
	moon_material.emission_enabled = true
	moon_material.emission = Color(0.913725, 0.913725, 0.8, 1)
	moon_material.emission_energy_multiplier = 0.2
	moon_material.rim_enabled = true
	moon_material.rim = 0.2
	moon_material.rim_tint = 0.5

	# Créer l'instance de la lune
	var moon = MeshInstance3D.new()
	moon.name = "Moon"
	moon.mesh = moon_mesh
	moon.set_surface_override_material(0, moon_material)
	moon_light.add_child(moon)

	# Positionner la lune
	moon.transform.origin = Vector3(7.39847, -16.0188, -31.8873)
	moon.transform.basis = Basis(Vector3(0.99953, 0.00819409, 0.0295323),
								Vector3(-0.00767016, 0.999811, -0.0178114),
								Vector3(-0.0296727, 0.0175765, 0.999404))

	# Ajouter le halo de la lune
	var moon_glow = OmniLight3D.new()
	moon_glow.name = "MoonGlow"
	moon_glow.light_color = Color(0.709804, 0.839216, 1, 1)
	moon_glow.light_energy = 5.0
	moon_glow.omni_range = 200.0
	moon_glow.omni_attenuation = 2.0
	moon.add_child(moon_glow)


func _process(_delta: float) -> void:
	if moon_instance:
		moon_instance.rotate_y(0.0001)
