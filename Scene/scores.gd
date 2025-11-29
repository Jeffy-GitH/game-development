extends Control

@onready var scores_list = $MarginContainer/ScrollContainer/VBoxContainer/ScoresList

func _ready():
	display_scores()

func display_scores():
	# Limpar lista existente
	for child in scores_list.get_children():
		child.queue_free()
	
	# Obter todas as pontuações
	var all_scores = ScoreManager.get_top_scores(100)
	
	if all_scores.is_empty():
		var empty_label = Label.new()
		empty_label.text = "Nenhuma pontuação ainda!"
		empty_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		empty_label.add_theme_font_override("font", preload("res://Fonts/Pixeled.ttf"))
		empty_label.add_theme_font_size_override("font_size", 10)
		scores_list.add_child(empty_label)
	else:
		for i in range(all_scores.size()):
			var score_data = all_scores[i]
			var score_label = Label.new()
			score_label.text = str(i + 1) + ". " + score_data["name"] + " - " + str(score_data["score"])
			score_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
			score_label.add_theme_font_override("font", preload("res://Fonts/Pixeled.ttf"))
			score_label.add_theme_font_size_override("font_size", 10)
			scores_list.add_child(score_label)

func _on_back_button_pressed():
	# Voltar para a cena de onde veio (menu principal ou game over)
	if Global.scores_previous_scene == "gameOver.tscn":
		get_tree().change_scene_to_file("res://Scene/gameOver.tscn")
	else:
		get_tree().change_scene_to_file("res://Scene/startScreen.tscn")
