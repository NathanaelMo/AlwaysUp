extends Node

const MIN_DB = -40.0
const MAX_DB = 0.0

# Chemins des fichiers audio (à adapter selon vos fichiers)
const MENU_MUSIC = "res://audio/game.mp3"
const GAME_MUSIC = "res://audio/game.mp3"
const JUMP_SOUND = "res://audio/jump.mp3"
const COLLECT_SOUND = "res://audio/bravo.mp3"

# Nœuds audio
var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var music_enabled = true
var sfx_enabled = true

func toggle_music():
    music_enabled = !music_enabled
    if music_enabled:
        music_player.stream_paused = false
    else:
        music_player.stop()

func toggle_sfx():
    sfx_enabled = !sfx_enabled

func _ready():
	# Créer les lecteurs audio
    music_player = AudioStreamPlayer.new()
    sfx_player = AudioStreamPlayer.new()
	
    add_child(music_player)
    add_child(sfx_player)
	
	# Charger les sons
    preload_audio()

func preload_audio():
    var sounds = [MENU_MUSIC, GAME_MUSIC, JUMP_SOUND, COLLECT_SOUND]
    for sound_path in sounds:
        var stream = load(sound_path)
        if stream:
            if sound_path.ends_with("theme.ogg"):
                stream.loop = true

func play_menu_music():
    _play_music(MENU_MUSIC)

func play_game_music():
    _play_music(GAME_MUSIC)

func play_jump_sound():
    _play_sfx(JUMP_SOUND)

func play_collect_sound():
    _play_sfx(COLLECT_SOUND)

func _play_music(path: String):
    if music_player.playing:
        music_player.stop()
    music_player.stream = load(path)
    music_player.play()

func _play_sfx(path: String):
    sfx_player.stream = load(path)
    sfx_player.play()

func set_music_volume(value: float):
    # value est entre 0 et 1
    if value <= 0:
        music_player.volume_db = -80 # Mute
    else:
        music_player.volume_db = lerp(MIN_DB, MAX_DB, value)

func set_sfx_volume(value: float):
    if value <= 0:
        sfx_player.volume_db = -80
    else:
        sfx_player.volume_db = lerp(MIN_DB, MAX_DB, value)

func get_music_volume() -> float:
    if music_player.volume_db <= -80:
        return 0
    return inverse_lerp(MIN_DB, MAX_DB, music_player.volume_db)

func get_sfx_volume() -> float:
    if sfx_player.volume_db <= -80:
        return 0
    return inverse_lerp(MIN_DB, MAX_DB, sfx_player.volume_db)