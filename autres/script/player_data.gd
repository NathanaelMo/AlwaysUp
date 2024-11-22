extends Node

const SAVE_FILE = "res://autres/highscores.dat"
const MAX_SCORES = 10

static var player_name = ""
static var high_scores = []

static func save_score(time: float, trophies: int):
	var score = {
		"name": player_name,
		"time": time,
		"trophies": trophies,
		"date": Time.get_datetime_string_from_system()
	}
	
	high_scores.append(score)
	high_scores.sort_custom(func(a, b): return a.time < b.time)
	
	if high_scores.size() > MAX_SCORES:
		high_scores.resize(MAX_SCORES)
	
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	file.store_var(high_scores)

static func load_scores():
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		high_scores = file.get_var()
	else:
		high_scores = []
	return high_scores