# checkpoint.gd
extends Area3D

signal checkpoint_collected(position)

var collected = false

func _ready():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		connect("checkpoint_collected", Callable(player, "collect_checkpoint"))
	connect("body_entered", _on_body_entered)
	
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property($Model, "rotation_degrees:y", 360, 2)

func _on_body_entered(body):
	if body.is_in_group("player") and not collected:
		collected = true
		emit_signal("checkpoint_collected", global_position)
		var collection_tween = create_tween()
		collection_tween.tween_property($Model, "scale", Vector3.ZERO, 0.3)
		collection_tween.tween_callback(queue_free)
