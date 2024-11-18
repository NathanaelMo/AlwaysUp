extends AnimationPlayer

const RUNNING_SPEED = 1.2

func _ready():
	setup_run_animation()
	speed_scale = RUNNING_SPEED

func setup_run_animation():
	var library = AnimationLibrary.new()
	var animation = Animation.new()
	animation.loop_mode = Animation.LOOP_LINEAR
	animation.length = 1.0 # Un cycle complet de course

	# Jambe gauche
	# Rotation de la cuisse gauche (LegL)
	var track_idx = animation.add_track(Animation.TYPE_ROTATION_3D)
	animation.track_set_path(track_idx, "../Model/LegL:rotation")
	for time in [0.0, 0.25, 0.5, 0.75, 1.0]:
		var angle = 0.7 * cos(time * PI * 2)
		animation.track_insert_key(track_idx, time, Quaternion(Vector3(1, 0, 0), angle))

	# Rotation du genou gauche (KneeL)
	track_idx = animation.add_track(Animation.TYPE_ROTATION_3D)
	animation.track_set_path(track_idx, "../Model/LegL/KneeL:rotation")
	for time in [0.0, 0.25, 0.5, 0.75, 1.0]:
		var angle = -0.4 * cos(time * PI * 2 + PI * 0.5)
		animation.track_insert_key(track_idx, time, Quaternion(Vector3(1, 0, 0), angle))

	# Jambe droite
	# Rotation de la cuisse droite (LegR)
	track_idx = animation.add_track(Animation.TYPE_ROTATION_3D)
	animation.track_set_path(track_idx, "../Model/LegR:rotation")
	for time in [0.0, 0.25, 0.5, 0.75, 1.0]:
		var angle = -0.7 * cos(time * PI * 2)
		animation.track_insert_key(track_idx, time, Quaternion(Vector3(1, 0, 0), angle))

	# Rotation du genou droit (KneeR)
	track_idx = animation.add_track(Animation.TYPE_ROTATION_3D)
	animation.track_set_path(track_idx, "../Model/LegR/KneeR:rotation")
	for time in [0.0, 0.25, 0.5, 0.75, 1.0]:
		var angle = 0.4 * cos(time * PI * 2 + PI * 0.5)
		animation.track_insert_key(track_idx, time, Quaternion(Vector3(1, 0, 0), angle))

	# Bras
	# Bras gauche
	track_idx = animation.add_track(Animation.TYPE_ROTATION_3D)
	animation.track_set_path(track_idx, "../Model/UpperBody/ArmL:rotation")
	for time in [0.0, 0.25, 0.5, 0.75, 1.0]:
		var angle = -0.5 * cos(time * PI * 2)
		animation.track_insert_key(track_idx, time, Quaternion(Vector3(1, 0, 0), angle))

	# Bras droit
	track_idx = animation.add_track(Animation.TYPE_ROTATION_3D)
	animation.track_set_path(track_idx, "../Model/UpperBody/ArmR:rotation")
	for time in [0.0, 0.25, 0.5, 0.75, 1.0]:
		var angle = 0.5 * cos(time * PI * 2)
		animation.track_insert_key(track_idx, time, Quaternion(Vector3(1, 0, 0), angle))

	# Oscillation du torse
	track_idx = animation.add_track(Animation.TYPE_ROTATION_3D)
	animation.track_set_path(track_idx, "../Model/UpperBody:rotation")
	for time in [0.0, 0.25, 0.5, 0.75, 1.0]:
		var angle = 0.1 * cos(time * PI * 2)
		animation.track_insert_key(track_idx, time, Quaternion(Vector3(1, 0, 0), angle))

	library.add_animation("run", animation)
	add_animation_library("", library)
