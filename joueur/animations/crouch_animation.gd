extends AnimationPlayer

func _ready():
    setup_crouch_animation()

func setup_crouch_animation():
    var library = AnimationLibrary.new()
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
    
    # Animation pour se relever
    var uncrouch_anim = animation.duplicate()
    uncrouch_anim.length = 0.2
    
    for i in range(uncrouch_anim.get_track_count()):
        var key_count = uncrouch_anim.track_get_key_count(i)
        if key_count >= 2:
            var first_key = uncrouch_anim.track_get_key_value(i, 0)
            var last_key = uncrouch_anim.track_get_key_value(i, key_count - 1)
            uncrouch_anim.track_set_key_value(i, 0, last_key)
            uncrouch_anim.track_set_key_value(i, key_count - 1, first_key)
    
    library.add_animation("uncrouch", uncrouch_anim)
    add_animation_library("", library)

func toggle_crouch(is_crouching: bool):
    
    # Arrêter toute animation en cours
    if is_playing():
        stop(true) # true = réinitialiser
    
    # Jouer la nouvelle animation
    if is_crouching:
        play("crouch")
    else:
        play("uncrouch")
