extends Node

@onready var run_animation = $RunAnimation
@onready var jump_animation = $JumpAnimation
@onready var crouch_animation = $CrouchAnimation

var was_jumping = false
var was_running = false
var was_crouching = false

enum AnimationPriority {
	IDLE = 0,
	CROUCH = 1,
	RUN = 2,
	JUMP = 3
}

var current_priority = AnimationPriority.IDLE

func _process(_delta):
	var player = get_parent()
	var is_moving = abs(player.velocity.x) > 0.1 or abs(player.velocity.z) > 0.1
	
	# Reset des animations quand on n'est plus accroupi
	if not player.is_crouching and was_crouching:
		reset_from_crouch()
		was_crouching = false
	
	# Déterminer la priorité de l'animation actuelle
	if player.is_jumping:
		handle_jump_animation()
	elif player.is_crouching:
		handle_crouch_animation(is_moving)
	elif is_moving and player.is_on_floor():
		handle_run_animation()
	else:
		handle_idle_animation()

func reset_from_crouch():
	current_priority = AnimationPriority.IDLE
	
	# Remettre la collision shape à sa position et taille normales
	var collision = get_parent().get_node("CollisionShape3D")
	if collision:
		collision.position = Vector3(0, 0.62, 0)
		collision.scale = Vector3(1, 1, 1)
	
	# Remettre le modèle en position debout
	var model = get_parent().get_node("Model")
	if not model:
		return
		
	var upper_body = model.get_node("UpperBody")
	if upper_body:
		# Réinitialiser la position et rotation du haut du corps
		upper_body.position = Vector3(0, 1.4, 0)
		upper_body.rotation = Vector3.ZERO
	
	# Réinitialiser les jambes
	if model.has_node("LegL"):
		var leg_l = model.get_node("LegL")
		leg_l.rotation = Vector3.ZERO
		if leg_l.has_node("KneeL"):
			leg_l.get_node("KneeL").rotation = Vector3.ZERO
	
	if model.has_node("LegR"):
		var leg_r = model.get_node("LegR")
		leg_r.rotation = Vector3.ZERO
		if leg_r.has_node("KneeR"):
			leg_r.get_node("KneeR").rotation = Vector3.ZERO

	# S'assurer que l'animation de désaccroupissement est jouée
	if crouch_animation:
		crouch_animation.play("uncrouch")
		crouch_animation.queue("RESET")

func handle_jump_animation():
	if current_priority < AnimationPriority.JUMP or not jump_animation.is_playing():
		current_priority = AnimationPriority.JUMP
		run_animation.stop()
		jump_animation.play("flip")
		was_jumping = true
		was_running = false

func handle_crouch_animation(is_moving):
	if current_priority != AnimationPriority.CROUCH or not was_crouching:
		current_priority = AnimationPriority.CROUCH
		run_animation.stop()
		
		if not was_crouching:
			if crouch_animation:
				crouch_animation.play("crouch")
			was_crouching = true
	
	if is_moving and run_animation:
		run_animation.play("run", -1, 0.7)
		was_running = true
	elif not is_moving and was_running:
		run_animation.stop()
		was_running = false

func handle_run_animation():
	if current_priority != AnimationPriority.RUN:
		current_priority = AnimationPriority.RUN
		if not run_animation.is_playing():
			run_animation.play("run")
			was_running = true

func handle_idle_animation():
	if was_running or was_jumping:
		current_priority = AnimationPriority.IDLE
		run_animation.stop()
		jump_animation.stop()
		reset_model_pose()
		was_running = false
		was_jumping = false

func reset_model_pose():
	var model = get_parent().get_node("Model")
	if not model or was_crouching:
		return
		
	model.rotation = Vector3.ZERO
	
	var upper_body = model.get_node_or_null("UpperBody")
	if upper_body:
		upper_body.position = Vector3(0, 1.4, 0)
		upper_body.rotation = Vector3.ZERO
		
		if upper_body.has_node("ArmL"):
			upper_body.get_node("ArmL").rotation = Vector3.ZERO
		if upper_body.has_node("ArmR"):
			upper_body.get_node("ArmR").rotation = Vector3.ZERO

	if model.has_node("LegL"):
		var leg_l = model.get_node("LegL")
		leg_l.rotation = Vector3.ZERO
		if leg_l.has_node("KneeL"):
			leg_l.get_node("KneeL").rotation = Vector3.ZERO
	
	if model.has_node("LegR"):
		var leg_r = model.get_node("LegR")
		leg_r.rotation = Vector3.ZERO
		if leg_r.has_node("KneeR"):
			leg_r.get_node("KneeR").rotation = Vector3.ZERO

func reset_animations():
	current_priority = AnimationPriority.IDLE
	run_animation.stop()
	jump_animation.stop()
	if crouch_animation and was_crouching:
		reset_from_crouch()
	was_jumping = false
	was_running = false
	was_crouching = false
	reset_model_pose()
