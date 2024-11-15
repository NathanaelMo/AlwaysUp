extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	setup_buttons()

func setup_buttons():
	var button_styles = {
		"PlayButton": Color(0.2, 0.8, 0.2),
		"OptionsButton": Color(0.2, 0.2, 0.8),
		"ScoresButton": Color(0.8, 0.2, 0.8),
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

func _on_button_pressed(button_text: String):
	match button_text:
		"Jouer":
			get_tree().change_scene_to_file("res://jeu.tscn")
		"Options":
			var options = preload("res://menu/options/options.tscn").instantiate()
			options.from_game = false
			add_child(options)
			$VBoxContainer.hide()  # Cache le menu principal
		"Quitter":
			get_tree().quit()
