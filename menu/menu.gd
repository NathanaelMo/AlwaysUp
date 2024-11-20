extends Control

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	setup_buttons()
	$NameDialog.hide()
	$ScoresDialog.hide()
	
	# Initialiser le fichier des scores s'il n'existe pas
	if not FileAccess.file_exists("user://highscores.dat"):
		var file = FileAccess.open("user://highscores.dat", FileAccess.WRITE)
		file.store_var([])

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
			$NameDialog.popup_centered()
		"Options":
			var options = preload("res://menu/options/options.tscn").instantiate()
			options.from_game = false
			add_child(options)
			$VBoxContainer.hide()
		"Top Scores":
			show_scores()
		"Quitter":
			get_tree().quit()

func _on_name_confirmed():
	var name = $NameDialog/VBoxContainer/NameEdit.text.strip_edges()
	if name.length() > 0:
		load("res://autres/script/player_data.gd").player_name = name
		get_tree().change_scene_to_file("res://jeu.tscn")
	else:
		$NameDialog/VBoxContainer/NameEdit.grab_focus()

func show_scores():
	var scores = load("res://autres/script/player_data.gd").load_scores()
	var scores_label = $ScoresDialog/VBoxContainer/ScrollContainer/ScoresLabel
	
	if scores.size() > 0:
		var scores_text = ""
		for i in range(scores.size()):
			var score = scores[i]
			var minutes = int(score.time) / 60
			var seconds = int(score.time) % 60
			scores_text += "%d. %s - %02d:%02d - %d trophées\n" % [
				i + 1,
				score.name,
				minutes,
				seconds,
				score.trophies
			]
		scores_label.text = scores_text
	else:
		scores_label.text = "Aucun score enregistré"
	
	$ScoresDialog.popup_centered()
