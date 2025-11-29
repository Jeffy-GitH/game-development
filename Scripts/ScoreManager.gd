extends Node

const SAVE_FILE = "user://highscores.save"

var scores: Array = []  # Array de dicionários: {"name": "ABC", "score": 100}

func _ready():
	load_scores()

func save_score(player_name: String, score: int):
	# Adicionar nova pontuação
	scores.append({"name": player_name, "score": score})
	
	# Ordenar por pontuação (maior primeiro)
	scores.sort_custom(func(a, b): return a["score"] > b["score"])
	
	# Manter apenas as top 100 pontuações
	if scores.size() > 100:
		scores = scores.slice(0, 100)
	
	# Salvar no arquivo
	save_scores()

func save_scores():
	var file = FileAccess.open(SAVE_FILE, FileAccess.WRITE)
	if file:
		var json_string = JSON.stringify(scores)
		file.store_string(json_string)
		file.close()
	else:
		print("Erro ao salvar pontuações!")

func load_scores():
	scores = []
	if FileAccess.file_exists(SAVE_FILE):
		var file = FileAccess.open(SAVE_FILE, FileAccess.READ)
		if file:
			var json_string = file.get_as_text()
			file.close()
			var json = JSON.new()
			var error = json.parse(json_string)
			if error == OK:
				scores = json.data
				if typeof(scores) != TYPE_ARRAY:
					scores = []
			else:
				scores = []
		else:
			scores = []
	else:
		scores = []

func get_top_scores(count: int = 10) -> Array:
	# Retorna as top N pontuações
	if scores.size() > count:
		return scores.slice(0, count)
	return scores

func get_top_3() -> Array:
	return get_top_scores(3)


