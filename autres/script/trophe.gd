extends Area3D

const TOTAL_TROPHIES = 10
static var collected_count = 0
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
		print("Trophy: Valid collection by player")
		collected = true
		collected_count += 1
		
		# Préparer et afficher le message
		var remaining = TOTAL_TROPHIES - collected_count
		var message = "Bravo ! Vous avez ramassé un trophée (%d/%d), encore %d à trouver !" % [
			collected_count,
			TOTAL_TROPHIES,
			remaining
		]
		
		# Afficher le message
		var MessageManager = load("res://autres/script/trophy_message.gd")
		MessageManager.show_message(message)
		
		# Animation de collection du trophée et suppression
		var collection_tween = create_tween()
		collection_tween.tween_property($Model, "scale", Vector3.ZERO, 0.3)
		collection_tween.finished.connect(func():
			print("Trophy: Collection animation finished, freeing trophy")
			queue_free()
		)
