# menu/options/options.gd
extends Control

@export var from_game: bool = false
var key_being_remapped = null
var input_actions = {
    "move_forward": "Avancer",
    "move_backward": "Reculer",
    "move_left": "Gauche",
    "move_right": "Droite",
    "ui_accept": "Sauter"
}

func _ready():
    process_mode = Node.PROCESS_MODE_ALWAYS
    if get_tree().paused:
        from_game = true
        
    $VBoxContainer/FullscreenCheck.button_pressed = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN
    _update_key_labels()
    $VBoxContainer/MusicCheck.button_pressed = AudioManager.music_enabled
    $VBoxContainer/SFXCheck.button_pressed = AudioManager.sfx_enabled

    $VBoxContainer/MusicVolumeSlider.value = AudioManager.get_music_volume()
    $VBoxContainer/SFXVolumeSlider.value = AudioManager.get_sfx_volume()
    
    # Connecter les signaux des sliders
    $VBoxContainer/MusicVolumeSlider.value_changed.connect(_on_music_volume_changed)
    $VBoxContainer/SFXVolumeSlider.value_changed.connect(_on_sfx_volume_changed)


func _input(event):
    if key_being_remapped and event is InputEventKey:
        if event.keycode != KEY_ESCAPE and event.keycode != KEY_ENTER:
            InputMap.action_erase_events(key_being_remapped)
            InputMap.action_add_event(key_being_remapped, event)
            key_being_remapped = null
            _update_key_labels()
            get_viewport().set_input_as_handled()

func _update_key_labels():
    for action in input_actions:
        var events = InputMap.action_get_events(action)
        if events.size() > 0:
            var event = events[0]
            var node = get_node_or_null("VBoxContainer/Keys/" + action)
            if node:
                node.text = OS.get_keycode_string(event.physical_keycode)

func _on_remap_key_pressed(action_name):
    key_being_remapped = action_name
    var button = get_node("VBoxContainer/Keys/" + action_name)
    if button:
        button.text = "..."

func _on_apply_pressed():
    if $VBoxContainer/FullscreenCheck.button_pressed:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
    else:
        DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
    _return_to_previous_menu()

    AudioManager.set_music_volume($VBoxContainer/MusicVolumeSlider.value)
    AudioManager.set_sfx_volume($VBoxContainer/SFXVolumeSlider.value)


func _on_back_pressed():
    _return_to_previous_menu()

func _return_to_previous_menu():
    if from_game:
        var pause_menu = get_parent()
        if pause_menu and pause_menu.has_node("VBoxContainer"):
            pause_menu.get_node("VBoxContainer").show()
            get_tree().paused = true
            Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
        queue_free()
    else:
        get_tree().change_scene_to_file("res://menu/menu.tscn")

func _on_music_check_toggled(enabled: bool):
    if AudioManager.music_enabled != enabled:
        AudioManager.toggle_music()

func _on_sfx_check_toggled(enabled: bool):
    if AudioManager.sfx_enabled != enabled:
        AudioManager.toggle_sfx()

func _on_music_volume_changed(value: float):
    AudioManager.set_music_volume(value)

func _on_sfx_volume_changed(value: float):
    AudioManager.set_sfx_volume(value)