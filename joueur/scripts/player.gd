extends CharacterBody3D

var speed = 15
var crouch_speed = 10
var sprint_speed = 25
var jump_force = 25
var has_double_jump = false
var can_double_jump = false
var gravity = 45
var mouse_sensitivity = 0.20

@onready var camera = $Camera3D
@onready var light_beam = $LightBeam
@onready var player_light = $PlayerLight
@onready var animation_manager = $AnimationManager
@onready var run_animation = $AnimationManager/RunAnimation if $AnimationManager else null
@onready var jump_animation = $AnimationManager/JumpAnimation if $AnimationManager else null
@onready var crouch_animation = $AnimationManager/CrouchAnimation if $AnimationManager else null
const TrophyManager = preload("res://autres/script/trophy_manager.gd")

var last_checkpoint_position: Vector3 = Vector3.ZERO
var spawn_position: Vector3
var has_checkpoint: bool = false
var is_jumping = false
var is_crouching = false
var is_sprinting = false
var sprint_enabled = false
var current_platform = null
var beam_active = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("player")
	spawn_position = global_position
	last_checkpoint_position = spawn_position
	has_checkpoint = false

	if light_beam:
		light_beam.visible = false
		light_beam.light_energy = 0.0
		if light_beam.has_node("OmniLight3D"):
			light_beam.get_node("OmniLight3D").light_energy = 0.0
	
	if player_light:
		player_light.visible = true
		player_light.light_energy = 2.0
	
	beam_active = false

	call_deferred("_connect_trophy_signals")

	if not animation_manager:
		push_warning("AnimationManager node not found!")
	if not run_animation:
		push_warning("RunAnimation node not found!")
	if not jump_animation:
		push_warning("JumpAnimation node not found!")

func _connect_trophy_signals():
	var trophy_manager = get_node("/root/TrophyManager")
	if trophy_manager:
		trophy_manager.all_trophies_collected.connect(func():
			has_double_jump = true
			print("Double saut activé!"))
	else:
		push_warning("TrophyManager not found!")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		is_jumping = false
		can_double_jump = has_double_jump
	
	if Input.is_action_just_pressed("ui_accept"):
		AudioManager.play_jump_sound()
		if is_on_floor():
			velocity.y = jump_force * (0.7 if is_crouching else 1.0)
			is_jumping = true
			if jump_animation:
				jump_animation.stop()
				jump_animation.play("flip")
				if run_animation:
					run_animation.stop()
		elif has_double_jump and can_double_jump:
			velocity.y = jump_force * 0.8
			can_double_jump = false
			is_jumping = true
			if jump_animation:
				AudioManager.play_jump_sound()
				jump_animation.play("flip")
	
	if Input.is_action_pressed("sprint") and sprint_enabled and not is_crouching:
		is_sprinting = true
		if run_animation:
			run_animation.speed_scale = 1.5
	else:
		is_sprinting = false
		if run_animation:
			run_animation.speed_scale = 1.0
	
	if Input.is_action_pressed("crouch"):
		if not is_crouching:
			is_crouching = true
			is_sprinting = false
			if crouch_animation:
				crouch_animation.toggle_crouch(true)
	elif is_crouching:
		var ceiling = is_ceiling_above()
		
		if not ceiling:
			is_crouching = false
			if crouch_animation:
				crouch_animation.toggle_crouch(false)
	
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		var current_speed = speed
		if is_sprinting:
			current_speed = sprint_speed
		elif is_crouching:
			current_speed = crouch_speed
		velocity.x = direction.x * current_speed
		velocity.z = direction.z * current_speed
		if is_on_floor() and not is_jumping and run_animation and not is_crouching:
			run_animation.play("run")
	else:
		var current_speed = speed
		if is_sprinting:
			current_speed = sprint_speed
		elif is_crouching:
			current_speed = crouch_speed
		velocity.x = move_toward(velocity.x, 0, current_speed)
		velocity.z = move_toward(velocity.z, 0, current_speed)
		if is_on_floor() and not is_jumping and not is_crouching:
			if run_animation:
				run_animation.stop()
			if animation_manager and animation_manager.has_method("reset_model_pose"):
				animation_manager.reset_model_pose()
	
	if current_platform:
		velocity += current_platform.get_platform_velocity()
	
	move_and_slide()
	update_current_platform()

func is_ceiling_above() -> bool:
	var space_state = get_world_3d().direct_space_state
	var ray_origin = global_position + Vector3(0, 0.5, 0)
	var ray_end = ray_origin + Vector3(0, 1.5, 0)
	
	var query = PhysicsRayQueryParameters3D.create(
		ray_origin,
		ray_end,
		0xFFFFFFFF, # Masque de collision (tout)
		[self.get_rid()] # Ignore le personnage lui-même
	)
	
	var result = space_state.intersect_ray(query)

	
	# Correction ici : retourne false s'il n'y a PAS de collision
	if result:
		return true
	else:
		return false # IMPORTANT : retourne false quand il n'y a pas d'obstacle

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
	AudioManager.play_collect_sound()
	last_checkpoint_position = pos
	has_checkpoint = true
	# Optionnel : ajouter un effet visuel ou sonore
	print("Checkpoint collecté à : ", pos)


# Nouvelle méthode pour activer/désactiver la possibilité de sprinter
func set_sprint_enabled(enabled: bool):
	sprint_enabled = enabled
	# Si on sort de la zone pendant un sprint, on arrête de sprinter
	if not enabled and is_sprinting:
		is_sprinting = false
		if run_animation:
			run_animation.speed_scale = 1.0
