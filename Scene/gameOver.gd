extends Control

@onready var score_label = $MarginContainer/ScrollContainer/VBoxContainer/ScoreLabel
@onready var name_input = $MarginContainer/ScrollContainer/VBoxContainer/NameInput
@onready var save_button = $MarginContainer/ScrollContainer/VBoxContainer/SaveButton
@onready var top_scores_list = $MarginContainer/ScrollContainer/VBoxContainer/TopScoresList

var final_score: int = 0
var score_saved: bool = false
var is_filtering: bool = false

func _ready():
	# Salvar a pontuação antes de qualquer reset
	final_score = Global.score
	
	# Resetar apenas os estados dos jogadores e vidas
	# A pontuação será resetada apenas quando o jogador escolher uma ação
	Global.player1_alive = true
	Global.player2_alive = true
	Global.lives = 3
	
	# Atualizar o label com a pontuação final
	score_label.text = "Pontuação: " + str(final_score)
	
	# Atualizar top 3 pontuações
	update_top_scores()
	
	# Configurar campo de nome
	name_input.text_changed.connect(_on_name_text_changed)
	name_input.grab_focus()

func _on_name_text_changed(new_text: String):
	if is_filtering:
		return
	
	# Converter para maiúsculas e limitar caracteres
	var filtered = ""
	for char in new_text:
		if (char >= "A" and char <= "Z") or (char >= "a" and char <= "z") or (char >= "0" and char <= "9"):
			filtered += char.to_upper()
	
	# Limitar a 8 caracteres
	if filtered.length() > 8:
		filtered = filtered.left(8)
	
	if filtered != new_text:
		is_filtering = true
		var cursor_pos = name_input.caret_column
		name_input.text = filtered
		name_input.caret_column = min(cursor_pos, filtered.length())
		is_filtering = false

func update_top_scores():
	var top_3 = ScoreManager.get_top_3()
	var scores_text = ""
	
	for i in range(3):
		if i < top_3.size():
			var player_name = top_3[i]["name"]
			var score = top_3[i]["score"]
			scores_text += str(i + 1) + ". " + player_name + " - " + str(score) + "\n"
		else:
			scores_text += str(i + 1) + ". --- 0\n"
	
	top_scores_list.text = scores_text.strip_edges()

func _on_save_button_pressed():
	if score_saved:
		return
	
	var player_name = name_input.text.strip_edges().to_upper()
	if player_name.is_empty():
		player_name = "AAA"
	
	# Limitar a 8 caracteres
	if player_name.length() > 8:
		player_name = player_name.left(8)
	
	# Salvar pontuação
	ScoreManager.save_score(player_name, final_score)
	score_saved = true
	
	# Atualizar top 3
	update_top_scores()
	
	# Desabilitar botão e campo
	save_button.disabled = true
	name_input.editable = false
	name_input.text = player_name

func _on_scores_button_pressed():
	Global.scores_previous_scene = "gameOver.tscn"
	get_tree().change_scene_to_file("res://Scene/scores.tscn")

func _on_restart_button_pressed():
	# Reiniciar o jogo do level 1
	Global.player1_alive = true
	Global.player2_alive = true
	Global.score = 0
	Global.score_at_level_start = 0
	Global.lives = 3
	get_tree().change_scene_to_file("res://Scene/level_01.tscn")

func _on_menu_button_pressed():
	# Voltar para o menu principal
	Global.player1_alive = true
	Global.player2_alive = true
	Global.score = 0
	Global.score_at_level_start = 0
	Global.lives = 3
	get_tree().change_scene_to_file("res://Scene/startScreen.tscn")
