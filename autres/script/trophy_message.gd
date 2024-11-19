extends Node

const DISPLAY_TIME = 3.0
const FADE_TIME = 1.0

static func show_message(message: String):
	# Créer le conteneur de message
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 100
	
	var center_container = CenterContainer.new()
	center_container.set_anchors_preset(Control.PRESET_FULL_RECT)
	center_container.grow_horizontal = Control.GROW_DIRECTION_BOTH
	center_container.grow_vertical = Control.GROW_DIRECTION_BOTH
	canvas_layer.add_child(center_container)
	
	# Créer le label
	var label = Label.new()
	label.text = message
	label.add_theme_color_override("font_color", Color(1, 0.9, 0))
	label.add_theme_font_size_override("font_size", 24)
	center_container.add_child(label)
	
	# Ajouter à l'arbre de scène
	var root = Engine.get_main_loop().get_root()
	root.add_child(canvas_layer)
	
	# Créer un timer pour le délai
	var timer = Timer.new()
	canvas_layer.add_child(timer)
	timer.wait_time = DISPLAY_TIME
	timer.one_shot = true
	timer.timeout.connect(func():
		# Animation de fondu
		var fade_tween = canvas_layer.create_tween()
		fade_tween.tween_property(label, "modulate", Color(1, 0.9, 0, 0), FADE_TIME)
		fade_tween.finished.connect(func():
			if is_instance_valid(canvas_layer):
				canvas_layer.queue_free()
		)
	)
	timer.start()
