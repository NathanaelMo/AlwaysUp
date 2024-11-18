extends AnimationPlayer

func _ready():
    setup_flip_animation()

func setup_flip_animation():
    var library = AnimationLibrary.new()
    var animation = Animation.new()
    animation.length = 0.4 # Un peu plus rapide
    animation.loop_mode = Animation.LOOP_NONE
    
    # Angles plus prononcés pour les jambes pendant le saut
    var track_idx = animation.add_track(Animation.TYPE_ROTATION_3D)
    animation.track_set_path(track_idx, "../Model/LegL:rotation")
    animation.track_insert_key(track_idx, 0.0, Quaternion(Vector3(1, 0, 0), 0))
    animation.track_insert_key(track_idx, 0.2, Quaternion(Vector3(1, 0, 0), 1.2)) # Plus prononcé
    animation.track_insert_key(track_idx, 0.4, Quaternion(Vector3(1, 0, 0), 0))
    
    track_idx = animation.add_track(Animation.TYPE_ROTATION_3D)
    animation.track_set_path(track_idx, "../Model/LegL/KneeL:rotation")
    animation.track_insert_key(track_idx, 0.0, Quaternion(Vector3(1, 0, 0), 0))
    animation.track_insert_key(track_idx, 0.2, Quaternion(Vector3(1, 0, 0), 1.5)) # Plus prononcé
    animation.track_insert_key(track_idx, 0.4, Quaternion(Vector3(1, 0, 0), 0))
    
    track_idx = animation.add_track(Animation.TYPE_ROTATION_3D)
    animation.track_set_path(track_idx, "../Model/LegR:rotation")
    animation.track_insert_key(track_idx, 0.0, Quaternion(Vector3(1, 0, 0), 0))
    animation.track_insert_key(track_idx, 0.2, Quaternion(Vector3(1, 0, 0), 1.2))
    animation.track_insert_key(track_idx, 0.4, Quaternion(Vector3(1, 0, 0), 0))
    
    track_idx = animation.add_track(Animation.TYPE_ROTATION_3D)
    animation.track_set_path(track_idx, "../Model/LegR/KneeR:rotation")
    animation.track_insert_key(track_idx, 0.0, Quaternion(Vector3(1, 0, 0), 0))
    animation.track_insert_key(track_idx, 0.2, Quaternion(Vector3(1, 0, 0), 1.5))
    animation.track_insert_key(track_idx, 0.4, Quaternion(Vector3(1, 0, 0), 0))
    
    # Bras levés plus haut pendant le saut
    track_idx = animation.add_track(Animation.TYPE_ROTATION_3D)
    animation.track_set_path(track_idx, "../Model/UpperBody/ArmL:rotation")
    animation.track_insert_key(track_idx, 0.0, Quaternion(Vector3(1, 0, 0), 0))
    animation.track_insert_key(track_idx, 0.2, Quaternion(Vector3(1, 0, 0), -1.2))
    animation.track_insert_key(track_idx, 0.4, Quaternion(Vector3(1, 0, 0), 0))
    
    track_idx = animation.add_track(Animation.TYPE_ROTATION_3D)
    animation.track_set_path(track_idx, "../Model/UpperBody/ArmR:rotation")
    animation.track_insert_key(track_idx, 0.0, Quaternion(Vector3(1, 0, 0), 0))
    animation.track_insert_key(track_idx, 0.2, Quaternion(Vector3(1, 0, 0), -1.2))
    animation.track_insert_key(track_idx, 0.4, Quaternion(Vector3(1, 0, 0), 0))
    
    library.add_animation("flip", animation)
    add_animation_library("", library)