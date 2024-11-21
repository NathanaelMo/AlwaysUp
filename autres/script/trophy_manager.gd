extends Node

signal all_trophies_collected
signal trophy_collected(count: int, total: int)
signal double_jump_unlocked

const TOTAL_TROPHIES = 1
var victory_shown = false
var collected_count = 0

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func reset():
	collected_count = 0
	victory_shown = false
	print("Trophies reset, count: ", collected_count)

func collect_trophy():
	collected_count += 1
	emit_signal("trophy_collected", collected_count, TOTAL_TROPHIES)
	
	var remaining = TOTAL_TROPHIES - collected_count
	var message = "Bravo ! Vous avez ramassé un trophée (%d/%d), encore %d à trouver !" % [
		collected_count,
		TOTAL_TROPHIES,
		remaining
	]
	
	if collected_count >= TOTAL_TROPHIES:
		message = "FÉLICITATIONS ! Vous avez trouvé tous les trophées ! Double saut débloqué !"
		if not victory_shown:
			victory_shown = true
			emit_signal("all_trophies_collected")
			emit_signal("double_jump_unlocked")
			_show_victory_screen()
	
	var MessageManager = load("res://autres/script/trophy_message.gd")
	MessageManager.show_message(message)

func _show_victory_screen():
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = 150
	canvas_layer.process_mode = Node.PROCESS_MODE_ALWAYS
	
	var panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_CENTER)
	panel.custom_minimum_size = Vector2(500, 300)
	panel.position = Vector2(-250, -150)
	
	var vbox = VBoxContainer.new()
	vbox.set_anchors_preset(Control.PRESET_FULL_RECT)
	vbox.alignment = BoxContainer.ALIGNMENT_CENTER
	vbox.add_theme_constant_override("separation", 20)
	
	var title = Label.new()
	title.text = "FÉLICITATIONS !"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 32)
	title.add_theme_color_override("font_color", Color(1, 0.9, 0))
	
	var message = Label.new()
	message.text = "Vous avez collecté tous les trophées !\nVotre récompense : Double saut activé !"
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	
	var continue_button = Button.new()
	continue_button.text = "Continuer"
	continue_button.custom_minimum_size = Vector2(150, 40)
	continue_button.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
	
	vbox.add_child(title)
	vbox.add_child(message)
	vbox.add_child(continue_button)
	panel.add_child(vbox)
	canvas_layer.add_child(panel)
	
	get_tree().get_root().add_child(canvas_layer)
	get_tree().paused = true
	
	continue_button.pressed.connect(func():
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		get_tree().paused = false
		canvas_layer.queue_free()
	)
	
	get_tree().get_root().add_child(canvas_layer)
