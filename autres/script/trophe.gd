extends Area3D

const TOTAL_TROPHIES = 11
var collected = false

func _ready():
	print("Trophy: Ready")
	connect("body_entered", _on_body_entered)
	
	# Animation de rotation
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property($Model, "rotation_degrees:y", 360, 2)
	
	# Animation de flottement
	var float_tween = create_tween()
	float_tween.set_loops()
	float_tween.tween_property($Model, "position:y", 0.2, 1)
	float_tween.tween_property($Model, "position:y", 0, 1)

func _on_body_entered(body):
	if body.is_in_group("player") and not collected:
		collected = true
		var trophy_manager = get_node("/root/TrophyManager")
		if trophy_manager:
			trophy_manager.collect_trophy()
		
		# Animation de collection du trophée et suppression
		var collection_tween = create_tween()
		collection_tween.tween_property($Model, "scale", Vector3.ZERO, 0.3)
		collection_tween.finished.connect(func():
			queue_free()
		)
