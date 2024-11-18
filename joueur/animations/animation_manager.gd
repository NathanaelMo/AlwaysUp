extends Node

@onready var run_animation = $RunAnimation
@onready var jump_animation = $JumpAnimation

var was_jumping = false
var was_running = false

# Constante pour définir les priorités d'animation
enum AnimationPriority {
	IDLE = 0,
	RUN = 1,
	JUMP = 2
}

var current_priority = AnimationPriority.IDLE

func _process(_delta):
	var player = get_parent()
	var is_moving = abs(player.velocity.x) > 0.1 or abs(player.velocity.z) > 0.1
	
	# Déterminer la priorité de l'animation actuelle
	if player.is_jumping:
		handle_jump_animation()
	elif is_moving and player.is_on_floor():
		handle_run_animation()
	else:
		handle_idle_animation()

func handle_jump_animation():
	if current_priority < AnimationPriority.JUMP or not jump_animation.is_playing():
		current_priority = AnimationPriority.JUMP
		run_animation.stop()
		jump_animation.play("flip")
		was_jumping = true
		was_running = false

func handle_run_animation():
	if current_priority < AnimationPriority.RUN and not was_jumping:
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
	if not model:
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
		upper_body.rotation = Vector3.ZERO
		
		if upper_body.has_node("ArmL"):
			upper_body.get_node("ArmL").rotation = Vector3.ZERO # Bras le long du corps
		if upper_body.has_node("ArmR"):
			upper_body.get_node("ArmR").rotation = Vector3.ZERO # Bras le long du corps

func reset_animations():
	current_priority = AnimationPriority.IDLE
	run_animation.stop()
	jump_animation.stop()
	was_jumping = false
	was_running = false
	reset_model_pose()
