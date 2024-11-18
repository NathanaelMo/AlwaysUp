extends Node

@onready var run_animation = $RunAnimation
@onready var jump_animation = $JumpAnimation
@onready var crouch_animation = $CrouchAnimation

var was_jumping = false
var was_running = false
var was_crouching = false

# Constante pour définir les priorités d'animation
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
	
	# Déterminer la priorité de l'animation actuelle
	if player.is_jumping:
		handle_jump_animation()
	elif player.is_crouching:
		handle_crouch_animation(is_moving)
	elif is_moving and player.is_on_floor():
		handle_run_animation()
	else:
		handle_idle_animation()

func handle_jump_animation():
	if current_priority < AnimationPriority.JUMP or not jump_animation.is_playing():
		current_priority = AnimationPriority.JUMP
		run_animation.stop()
		
		# Si le joueur était accroupi, maintenir l'animation d'accroupissement
		if was_crouching and crouch_animation:
			crouch_animation.toggle_crouch(true)
		
		jump_animation.play("flip")
		was_jumping = true
		was_running = false

func handle_crouch_animation(is_moving):
	if current_priority != AnimationPriority.CROUCH or not crouch_animation.is_playing():
		current_priority = AnimationPriority.CROUCH
		run_animation.stop()
		
		if not was_crouching:
			if crouch_animation:
				crouch_animation.toggle_crouch(true)
			was_crouching = true
	
	# Animation de course accroupie si le joueur se déplace
	if is_moving and not was_running and run_animation:
		run_animation.play("run", -1, 0.7) # Vitesse réduite pour la course accroupie
		was_running = true
	elif not is_moving and was_running:
		run_animation.stop()
		was_running = false

func handle_run_animation():
	if current_priority < AnimationPriority.RUN and not was_jumping:
		current_priority = AnimationPriority.RUN
		
		# Si on était accroupi, jouer l'animation de relèvement
		if was_crouching and crouch_animation:
			crouch_animation.toggle_crouch(false)
			was_crouching = false
		
		if not run_animation.is_playing():
			run_animation.play("run")
			was_running = true

func handle_idle_animation():
	if was_running or was_jumping:
		current_priority = AnimationPriority.IDLE
		run_animation.stop()
		jump_animation.stop()
		
		# Si on était accroupi, jouer l'animation de relèvement
		if was_crouching and crouch_animation:
			crouch_animation.toggle_crouch(false)
			was_crouching = false
		
		reset_model_pose()
		was_running = false
		was_jumping = false

func reset_model_pose():
	var model = get_parent().get_node("Model")
	if not model:
		return
	
	# Ne pas réinitialiser la pose si on est accroupi
	if was_crouching:
		return
		
	# Reset principal
	model.rotation = Vector3.ZERO
	
	# Jambes droites
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
	
	# Bras le long du corps
	if model.has_node("UpperBody"):
		var upper_body = model.get_node("UpperBody")
		upper_body.position = Vector3(0, 1.4, 0) # Position haute normale
		upper_body.rotation = Vector3.ZERO
		
		if upper_body.has_node("ArmL"):
			upper_body.get_node("ArmL").rotation = Vector3.ZERO
		if upper_body.has_node("ArmR"):
			upper_body.get_node("ArmR").rotation = Vector3.ZERO

func reset_animations():
	current_priority = AnimationPriority.IDLE
	run_animation.stop()
	jump_animation.stop()
	if crouch_animation and was_crouching:
		crouch_animation.toggle_crouch(false)
	was_jumping = false
	was_running = false
	was_crouching = false
	reset_model_pose()
