extends CharacterBody3D

var speed = 15
var jump_force = 25
var gravity = 45
var mouse_sensitivity = 0.20

@onready var camera = $Camera3D
@onready var light_beam = $LightBeam
@onready var player_light = $PlayerLight
@onready var animation_manager = $AnimationManager
@onready var run_animation = $AnimationManager/RunAnimation if $AnimationManager else null
@onready var jump_animation = $AnimationManager/JumpAnimation if $AnimationManager else null

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
	last_checkpoint_position = spawn_position
	has_checkpoint = false

	# Configuration initiale des lumières
	if light_beam:
		light_beam.visible = false
		light_beam.light_energy = 0.0
		if light_beam.has_node("OmniLight3D"):
			light_beam.get_node("OmniLight3D").light_energy = 0.0
	
	# La lumière ambiante du joueur est toujours active
	if player_light:
		player_light.visible = true
		player_light.light_energy = 2.0
	
	beam_active = false

	# Vérification que les nœuds d'animation sont bien chargés
	if not animation_manager:
		push_warning("AnimationManager node not found!")
	if not run_animation:
		push_warning("RunAnimation node not found!")
	if not jump_animation:
		push_warning("JumpAnimation node not found!")


func _physics_process(delta):
	# Appliquer la gravité
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Gérer le saut
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
		is_jumping = true
		if jump_animation:
			jump_animation.stop()
			jump_animation.play("flip")
			if run_animation:
				run_animation.stop()
	
	if is_jumping and is_on_floor():
		is_jumping = false
		
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		if is_on_floor() and not is_jumping and run_animation:
			run_animation.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		if is_on_floor() and not is_jumping:
			if run_animation:
				run_animation.stop()
			if animation_manager and animation_manager.has_method("reset_model_pose"):
				animation_manager.reset_model_pose()
	
	if current_platform:
		velocity += current_platform.get_platform_velocity()
	
	move_and_slide()
	update_current_platform()

func toggle_beam():
	if light_beam:
		beam_active = !beam_active
		if beam_active:
			# Allumer uniquement la lampe torche
			var tween = create_tween()
			light_beam.visible = true
			tween.tween_property(light_beam, "light_energy", 8.0, 0.2)
			if light_beam.has_node("OmniLight3D"):
				tween.parallel().tween_property(light_beam.get_node("OmniLight3D"), "light_energy", 5.0, 0.2)
		else:
			# Éteindre uniquement la lampe torche
			var tween = create_tween()
			tween.tween_property(light_beam, "light_energy", 0.0, 0.1)
			if light_beam.has_node("OmniLight3D"):
				tween.parallel().tween_property(light_beam.get_node("OmniLight3D"), "light_energy", 0.0, 0.1)
			await tween.finished
			light_beam.visible = false

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
	elif event.is_action_pressed("ui_cancel"):
		var menu = preload("res://menu/pause_menu.tscn").instantiate()
		add_child(menu)
		get_tree().paused = true
	elif event.is_action_pressed("teleport_checkpoint"):
		if has_checkpoint:
			global_position = last_checkpoint_position + Vector3(0, 2, 0)
			velocity = Vector3.ZERO
		else:
			global_position = spawn_position
			velocity = Vector3.ZERO
	elif event.is_action_pressed("toggle_beam"):
		toggle_beam()

func update_current_platform():
	if is_on_floor():
		var collision = get_last_slide_collision()
		if collision and collision.get_collider() is StaticBody3D and collision.get_collider().has_method("get_platform_velocity"):
			current_platform = collision.get_collider()
		else:
			current_platform = null
	else:
		current_platform = null

func collect_checkpoint(pos):
	last_checkpoint_position = pos
	has_checkpoint = true
	# Optionnel : ajouter un effet visuel ou sonore
	print("Checkpoint collecté à : ", pos)
