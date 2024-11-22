extends Area3D

var end_screen: Control

func _ready():
	connect("body_entered", _on_body_entered)
	
	var tween = create_tween()
	tween.set_loops()
	tween.tween_property($Model, "rotation_degrees:y", 360, 2)

func _on_body_entered(body):
	if body.is_in_group("player"):
		var chrono = get_node("/root/Jeu/Chrono")
		var elapsed_time = chrono.elapsed_time if chrono else 0.0
		
		# Chargez l'instance de trophée correctement
		var trophy_manager = get_node("/root/TrophyManager") # Récupère le gestionnaire de trophées
		var trophies_collected = trophy_manager.collected_count # Accède à la propriété via l'instance
		
		var player_data = load("res://autres/script/player_data.gd")
		
		# Sauvegarder le score
		player_data.save_score(elapsed_time, trophies_collected)
		
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		end_screen = Control.new()
		end_screen.set_anchors_preset(Control.PRESET_FULL_RECT)
		
		var background = ColorRect.new()
		background.set_anchors_preset(Control.PRESET_FULL_RECT)
		background.color = Color(0, 0, 0, 0.8)
		end_screen.add_child(background)
		
		var container = VBoxContainer.new()
		container.set_anchors_preset(Control.PRESET_CENTER)
		container.grow_horizontal = Control.GROW_DIRECTION_BOTH
		container.grow_vertical = Control.GROW_DIRECTION_BOTH
		container.add_theme_constant_override("separation", 20)
		end_screen.add_child(container)
		
		var title = Label.new()
		title.text = "Félicitations %s !" % player_data.player_name
		title.add_theme_font_size_override("font_size", 48)
		title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		container.add_child(title)
		
		var minutes = int(elapsed_time) / 60
		var seconds = int(elapsed_time) % 60
		var time_label = Label.new()
		time_label.text = "Temps : %02d:%02d" % [minutes, seconds]
		time_label.add_theme_font_size_override("font_size", 32)
		time_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		container.add_child(time_label)
		
		var trophy_label = Label.new()
		trophy_label.text = "Trophées : %d/%d" % [trophies_collected, TrophyManager.TOTAL_TROPHIES]
		trophy_label.add_theme_font_size_override("font_size", 32)
		trophy_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		container.add_child(trophy_label)
		
		var menu_button = Button.new()
		menu_button.text = "Retour au menu"
		menu_button.custom_minimum_size = Vector2(200, 50)
		menu_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		menu_button.pressed.connect(func():
			end_screen.queue_free()
			get_tree().paused = false
			trophy_manager.collected_count = 0 # Réinitialiser le compteur de trophées
			get_tree().change_scene_to_file("res://menu/menu.tscn")
		)
		container.add_child(menu_button)
		
		end_screen.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().root.add_child(end_screen)
		get_tree().paused = true


func _exit_tree():
	if end_screen and is_instance_valid(end_screen):
		end_screen.queue_free()
