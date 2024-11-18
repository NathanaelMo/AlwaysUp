extends Area3D

signal checkpoint_collected(position)

var collected = false

func _ready():
	connect("body_entered", _on_body_entered)
	
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property($Model, "rotation_degrees:y", 360, 2)

func _on_body_entered(body):
	print("Collected status:", collected)
	
	if body.is_in_group("player") and not collected:
		collected = true
		# Connecter le signal au moment de la collision
		if not is_connected("checkpoint_collected", Callable(body, "collect_checkpoint")):
			connect("checkpoint_collected", Callable(body, "collect_checkpoint"))
		
		print("Emitting signal with position:", global_position)
		emit_signal("checkpoint_collected", global_position)
		
		var collection_tween = create_tween()
		collection_tween.tween_property($Model, "scale", Vector3.ZERO, 0.3)
		collection_tween.tween_callback(queue_free)
