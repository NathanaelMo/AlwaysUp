extends CharacterBody3D

var speed = 15
var jump_force = 20
var gravity = 45
var mouse_sensitivity = 0.20

@onready var camera = $Camera3D
@onready var animation_player = $AnimationPlayer

var is_jumping = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	# Appliquer la gravité
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Gérer le saut
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force
		is_jumping = true
		animation_player.play("jump")
	
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
		if is_on_floor() and not is_jumping and not animation_player.is_playing():
			animation_player.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		if is_on_floor() and animation_player.current_animation == "walk":
			animation_player.stop()
	
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))
		camera.rotate_x(deg_to_rad(-event.relative.y * mouse_sensitivity))
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))
