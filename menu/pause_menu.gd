extends Control

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	setup_buttons()
	setup_dialog()

func setup_buttons():
	var button_styles = {
		"ContinueButton": Color(0.2, 0.8, 0.2),
		"OptionsButton": Color(0.2, 0.2, 0.8),
		"RestartButton": Color(0.2, 0.8, 0.2),
		"MainMenuButton": Color(0.8, 0.2, 0.8),
		"QuitButton": Color(0.8, 0.2, 0.2)
	}
	
	for button_name in button_styles:
		var button = $VBoxContainer.get_node_or_null(button_name)
		if button:
			button.add_theme_color_override("font_color", Color.WHITE)
			button.add_theme_stylebox_override("normal", create_stylebox(button_styles[button_name]))

func create_stylebox(color: Color) -> StyleBoxFlat:
	var style = StyleBoxFlat.new()
	style.bg_color = color
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_left = 8
	style.corner_radius_bottom_right = 8
	return style

func _on_button_pressed(button_name: String):
	match button_name:
		"Continue":
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			get_tree().paused = false
			queue_free()
		"Restart":
			$ConfirmationDialog.show()
		"Options":
			var options = preload("res://menu/options/options.tscn").instantiate()
			options.from_game = true
			add_child(options)
			$VBoxContainer.hide()
		"MainMenu":
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			get_tree().paused = false
			get_tree().change_scene_to_file("res://menu/menu.tscn")
		"Quit":
			get_tree().quit()

func _on_confirmation_confirmed():
	# Réinitialiser le compteur de trophées avant de recharger la scène
	var trophy_manager = get_node("/root/TrophyManager")
	if trophy_manager:
		trophy_manager.reset()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	get_tree().paused = false
	get_tree().reload_current_scene()

func setup_dialog():
	var dialog = $ConfirmationDialog
	dialog.position = Vector2(
		(get_viewport().get_visible_rect().size.x - dialog.size.x) / 2,
		(get_viewport().get_visible_rect().size.y - dialog.size.y) / 2
	)