extends CharacterBody3D

var speed = 15
var jump_force = 25
var gravity = 45
var mouse_sensitivity = 0.20

@onready var camera = $Camera3D
@onready var light_beam = $LightBeam
@onready var animation_manager = $AnimationManager
@onready var run_animation = $AnimationManager/RunAnimation
@onready var jump_animation = $AnimationManager/JumpAnimation


var last_checkpoint_position: Vector3 = Vector3.ZERO
var spawn_position: Vector3
var has_checkpoint: bool = false
var is_jumping = false
var current_platform = null
var beam_active = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")
	spawn_position = global_position
	if light_beam:
		light_beam.visible = false
		beam_active = false

	if event.is_action_pressed("teleport_checkpoint"):
		if has_checkpoint:
			global_position = last_checkpoint_position + Vector3(0, 2, 0)
	else:
		global_position = spawn_position

func _physics_process(delta):
	# Appliquer la gravité
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Gérer le saut
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
		is_jumping = true
		# Forcer l'animation de saut
		if jump_animation:
			jump_animation.stop() # Arrête toute animation de saut en cours
			jump_animation.play("flip")
			run_animation.stop()
	
	# Vérifier si le saut est terminé
	if is_jumping and is_on_floor():
		is_jumping = false
		
	# Obtenir la direction d'entrée et normaliser
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	# Appliquer le mouvement horizontal
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if is_on_floor() and not is_jumping:
			run_animation.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		if is_on_floor() and not is_jumping:
			run_animation.stop()
			animation_manager.reset_model_pose() # Reset la pose quand on arrête de bouger
	
	# Appliquer le mouvement de la plateforme si le joueur est dessus
	if current_platform:
		velocity += current_platform.get_platform_velocity()
	
	move_and_slide()
	
	# Mettre à jour la plateforme actuelle
	update_current_platform()

func toggle_beam():
	if light_beam:
		beam_active = !beam_active
		if beam_active:
			# Allumer avec une transition douce
			var tween = create_tween()
			light_beam.visible = true
			tween.tween_property(light_beam, "light_energy", 8.0, 0.2)
			tween.parallel().tween_property(light_beam.get_node("OmniLight3D"), "light_energy", 5.0, 0.2)
		else:
			# Éteindre avec une transition douce
			var tween = create_tween()
			tween.tween_property(light_beam, "light_energy", 0.0, 0.1)
			tween.parallel().tween_property(light_beam.get_node("OmniLight3D"), "light_energy", 0.0, 0.1)
			# Attendre la fin de la transition avant de cacher complètement la lumière
			await tween.finished
			light_beam.visible = false

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	if event.is_action_pressed("ui_cancel"):
		var menu = preload("res://menu/pause_menu.tscn").instantiate()
		add_child(menu)
		get_tree().paused = true

func update_current_platform():
	if is_on_floor():
		var collision = get_last_slide_collision()
		if collision and collision.get_collider() is StaticBody3D and collision.get_collider().has_method("get_platform_velocity"):
			current_platform = collision.get_collider()
		else:
			current_platform = null
	else:
		current_platform = null

func _unhandled_input(event):
	if event.is_action_pressed("teleport_checkpoint") and has_checkpoint:
		global_position = last_checkpoint_position + Vector3(0, 2, 0) # Légèrement au-dessus pour éviter les collisions

func collect_checkpoint(pos):
	print("Checkpoint collected at: ", pos) # Debug
	last_checkpoint_position = pos
	has_checkpoint = true