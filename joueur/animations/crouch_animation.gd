extends AnimationPlayer

func _ready():
    setup_crouch_animation()

func setup_crouch_animation():
    var library = AnimationLibrary.new()
    
    # Animation d'accroupissement
    var animation = Animation.new()
    animation.length = 0.3
    animation.loop_mode = Animation.LOOP_NONE
    
    # Animation du haut du corps
    var track_body_pos = animation.add_track(Animation.TYPE_POSITION_3D)
    animation.track_set_path(track_body_pos, "../Model/UpperBody:position")
    animation.track_insert_key(track_body_pos, 0.0, Vector3(0, 1.4, 0))
    animation.track_insert_key(track_body_pos, 0.3, Vector3(0, 0.7, 0))
    
    # Animation des jambes - flexion des genoux
    var track_leg_l = animation.add_track(Animation.TYPE_ROTATION_3D)
    animation.track_set_path(track_leg_l, "../Model/LegL:rotation")
    animation.track_insert_key(track_leg_l, 0.0, Quaternion(Vector3.RIGHT.normalized(), 0))
    animation.track_insert_key(track_leg_l, 0.3, Quaternion(Vector3.RIGHT.normalized(), 0.7))
    
    var track_leg_r = animation.add_track(Animation.TYPE_ROTATION_3D)
    animation.track_set_path(track_leg_r, "../Model/LegR:rotation")
    animation.track_insert_key(track_leg_r, 0.0, Quaternion(Vector3.RIGHT.normalized(), 0))
    animation.track_insert_key(track_leg_r, 0.3, Quaternion(Vector3.RIGHT.normalized(), 0.7))
    
    var track_knee_l = animation.add_track(Animation.TYPE_ROTATION_3D)
    animation.track_set_path(track_knee_l, "../Model/LegL/KneeL:rotation")
    animation.track_insert_key(track_knee_l, 0.0, Quaternion(Vector3.RIGHT.normalized(), 0))
    animation.track_insert_key(track_knee_l, 0.3, Quaternion(Vector3.RIGHT.normalized(), 1.2))
    
    var track_knee_r = animation.add_track(Animation.TYPE_ROTATION_3D)
    animation.track_set_path(track_knee_r, "../Model/LegR/KneeR:rotation")
    animation.track_insert_key(track_knee_r, 0.0, Quaternion(Vector3.RIGHT.normalized(), 0))
    animation.track_insert_key(track_knee_r, 0.3, Quaternion(Vector3.RIGHT.normalized(), 1.2))
    
    # Légère inclinaison du dos
    var track_body_rot = animation.add_track(Animation.TYPE_ROTATION_3D)
    animation.track_set_path(track_body_rot, "../Model/UpperBody:rotation")
    animation.track_insert_key(track_body_rot, 0.0, Quaternion(Vector3.RIGHT.normalized(), 0))
    animation.track_insert_key(track_body_rot, 0.3, Quaternion(Vector3.RIGHT.normalized(), 0.2))
    
    # Animation de la CollisionShape
    var track_collision_scale = animation.add_track(Animation.TYPE_SCALE_3D)
    animation.track_set_path(track_collision_scale, "../CollisionShape3D:scale")
    animation.track_insert_key(track_collision_scale, 0.0, Vector3(1, 1, 1))
    animation.track_insert_key(track_collision_scale, 0.3, Vector3(1, 0.5, 1))
    
    var track_collision_pos = animation.add_track(Animation.TYPE_POSITION_3D)
    animation.track_set_path(track_collision_pos, "../CollisionShape3D:position")
    animation.track_insert_key(track_collision_pos, 0.0, Vector3(0, 0.62, 0))
    animation.track_insert_key(track_collision_pos, 0.3, Vector3(0, 0.31, 0))
    
    library.add_animation("crouch", animation)

    # Animation pour se relever (uncrouch)
    var uncrouch_anim = Animation.new()
    uncrouch_anim.length = 0.2
    uncrouch_anim.loop_mode = Animation.LOOP_NONE
    
    # Copier tous les tracks avec des valeurs inversées
    track_body_pos = uncrouch_anim.add_track(Animation.TYPE_POSITION_3D)
    uncrouch_anim.track_set_path(track_body_pos, "../Model/UpperBody:position")
    uncrouch_anim.track_insert_key(track_body_pos, 0.0, Vector3(0, 0.7, 0))
    uncrouch_anim.track_insert_key(track_body_pos, 0.2, Vector3(0, 1.4, 0))
    
    track_leg_l = uncrouch_anim.add_track(Animation.TYPE_ROTATION_3D)
    uncrouch_anim.track_set_path(track_leg_l, "../Model/LegL:rotation")
    uncrouch_anim.track_insert_key(track_leg_l, 0.0, Quaternion(Vector3.RIGHT.normalized(), 0.7))
    uncrouch_anim.track_insert_key(track_leg_l, 0.2, Quaternion(Vector3.RIGHT.normalized(), 0))
    
    track_leg_r = uncrouch_anim.add_track(Animation.TYPE_ROTATION_3D)
    uncrouch_anim.track_set_path(track_leg_r, "../Model/LegR:rotation")
    uncrouch_anim.track_insert_key(track_leg_r, 0.0, Quaternion(Vector3.RIGHT.normalized(), 0.7))
    uncrouch_anim.track_insert_key(track_leg_r, 0.2, Quaternion(Vector3.RIGHT.normalized(), 0))
    
    track_knee_l = uncrouch_anim.add_track(Animation.TYPE_ROTATION_3D)
    uncrouch_anim.track_set_path(track_knee_l, "../Model/LegL/KneeL:rotation")
    uncrouch_anim.track_insert_key(track_knee_l, 0.0, Quaternion(Vector3.RIGHT.normalized(), 1.2))
    uncrouch_anim.track_insert_key(track_knee_l, 0.2, Quaternion(Vector3.RIGHT.normalized(), 0))
    
    track_knee_r = uncrouch_anim.add_track(Animation.TYPE_ROTATION_3D)
    uncrouch_anim.track_set_path(track_knee_r, "../Model/LegR/KneeR:rotation")
    uncrouch_anim.track_insert_key(track_knee_r, 0.0, Quaternion(Vector3.RIGHT.normalized(), 1.2))
    uncrouch_anim.track_insert_key(track_knee_r, 0.2, Quaternion(Vector3.RIGHT.normalized(), 0))
    
    track_body_rot = uncrouch_anim.add_track(Animation.TYPE_ROTATION_3D)
    uncrouch_anim.track_set_path(track_body_rot, "../Model/UpperBody:rotation")
    uncrouch_anim.track_insert_key(track_body_rot, 0.0, Quaternion(Vector3.RIGHT.normalized(), 0.2))
    uncrouch_anim.track_insert_key(track_body_rot, 0.2, Quaternion(Vector3.RIGHT.normalized(), 0))
    
    track_collision_scale = uncrouch_anim.add_track(Animation.TYPE_SCALE_3D)
    uncrouch_anim.track_set_path(track_collision_scale, "../CollisionShape3D:scale")
    uncrouch_anim.track_insert_key(track_collision_scale, 0.0, Vector3(1, 0.5, 1))
    uncrouch_anim.track_insert_key(track_collision_scale, 0.2, Vector3(1, 1, 1))
    
    track_collision_pos = uncrouch_anim.add_track(Animation.TYPE_POSITION_3D)
    uncrouch_anim.track_set_path(track_collision_pos, "../CollisionShape3D:position")
    uncrouch_anim.track_insert_key(track_collision_pos, 0.0, Vector3(0, 0.31, 0))
    uncrouch_anim.track_insert_key(track_collision_pos, 0.2, Vector3(0, 0.62, 0))
    
    library.add_animation("uncrouch", uncrouch_anim)
    
    # Animation RESET
    var reset_anim = Animation.new()
    reset_anim.length = 0.01
    reset_anim.loop_mode = Animation.LOOP_NONE
    
    # Ajouter tous les tracks avec les valeurs par défaut
    var track_reset_body = reset_anim.add_track(Animation.TYPE_POSITION_3D)
    reset_anim.track_set_path(track_reset_body, "../Model/UpperBody:position")
    reset_anim.track_insert_key(track_reset_body, 0.0, Vector3(0, 1.4, 0))
    
    var track_reset_leg_l = reset_anim.add_track(Animation.TYPE_ROTATION_3D)
    reset_anim.track_set_path(track_reset_leg_l, "../Model/LegL:rotation")
    reset_anim.track_insert_key(track_reset_leg_l, 0.0, Quaternion(Vector3.RIGHT.normalized(), 0))
    
    var track_reset_leg_r = reset_anim.add_track(Animation.TYPE_ROTATION_3D)
    reset_anim.track_set_path(track_reset_leg_r, "../Model/LegR:rotation")
    reset_anim.track_insert_key(track_reset_leg_r, 0.0, Quaternion(Vector3.RIGHT.normalized(), 0))
    
    var track_reset_knee_l = reset_anim.add_track(Animation.TYPE_ROTATION_3D)
    reset_anim.track_set_path(track_reset_knee_l, "../Model/LegL/KneeL:rotation")
    reset_anim.track_insert_key(track_reset_knee_l, 0.0, Quaternion(Vector3.RIGHT.normalized(), 0))
    
    var track_reset_knee_r = reset_anim.add_track(Animation.TYPE_ROTATION_3D)
    reset_anim.track_set_path(track_reset_knee_r, "../Model/LegR/KneeR:rotation")
    reset_anim.track_insert_key(track_reset_knee_r, 0.0, Quaternion(Vector3.RIGHT.normalized(), 0))
    
    var track_reset_body_rot = reset_anim.add_track(Animation.TYPE_ROTATION_3D)
    reset_anim.track_set_path(track_reset_body_rot, "../Model/UpperBody:rotation")
    reset_anim.track_insert_key(track_reset_body_rot, 0.0, Quaternion(Vector3.RIGHT.normalized(), 0))
    
    var track_reset_collision_scale = reset_anim.add_track(Animation.TYPE_SCALE_3D)
    reset_anim.track_set_path(track_reset_collision_scale, "../CollisionShape3D:scale")
    reset_anim.track_insert_key(track_reset_collision_scale, 0.0, Vector3(1, 1, 1))
    
    var track_reset_collision_pos = reset_anim.add_track(Animation.TYPE_POSITION_3D)
    reset_anim.track_set_path(track_reset_collision_pos, "../CollisionShape3D:position")
    reset_anim.track_insert_key(track_reset_collision_pos, 0.0, Vector3(0, 0.62, 0))
    
    library.add_animation("RESET", reset_anim)
    add_animation_library("", library)

func toggle_crouch(is_crouching: bool):
    if is_playing():
        stop()
    
    if is_crouching:
        play("crouch")
    else:
        # Jouer l'animation de désaccroupissement suivie de la réinitialisation
        play("uncrouch")
        queue("RESET")