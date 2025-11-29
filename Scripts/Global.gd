extends Node

var player1_alive = true
var player2_alive = true

var score: int = 0
var score_at_level_start: int = 0  # Score quando a fase começou
var lives: int = 3
var is_restarting = false
var scores_previous_scene: String = "startScreen.tscn"  # Cena de onde veio para a tela de pontuações

func _ready():
	# Conectar ao sinal de mudança de cena para salvar o score inicial
	get_tree().scene_changed.connect(_on_scene_changed)

func _on_scene_changed():
	# Salvar o score atual quando uma nova fase é carregada
	# (mas não se for gameOver ou startScreen)
	var current_scene = get_tree().current_scene
	if current_scene:
		var scene_name = current_scene.scene_file_path.get_file()
		if scene_name != "gameOver.tscn" and scene_name != "startScreen.tscn":
			score_at_level_start = score

func _process(_delta: float) -> void:
	
	print(score)
	# Não processar restart se estiver na tela de Game Over ou Start Screen
	var current_scene = get_tree().current_scene
	if current_scene:
		var scene_name = current_scene.scene_file_path.get_file()
		if scene_name == "gameOver.tscn" or scene_name == "startScreen.tscn":
			return
	
	if not is_restarting:
		restart(0.4)
	pass

func restart(time: float):
	if not player1_alive and not player2_alive and not is_restarting:
		is_restarting = true
		await get_tree().create_timer(time).timeout
		lives -= 1
		if lives <= 0:
			# Game Over - voltar para o menu
			game_over()
		else:
			# Reiniciar fase com menos uma vida
			# Voltar o score para o valor que tinha quando a fase começou
			# (subtraindo apenas as moedas coletadas na fase atual)
			var current_scene = get_tree().current_scene
			if current_scene:
				var scene_path = current_scene.scene_file_path
				if scene_path:
					# Resetar score antes de mudar a cena
					score = score_at_level_start
					player1_alive = true
					player2_alive = true
					get_tree().change_scene_to_file(scene_path)
				else:
					# Fallback: tentar reload se não tiver caminho
					score = score_at_level_start
					get_tree().reload_current_scene()
					player1_alive = true
					player2_alive = true
			else:
				# Se não houver cena atual, voltar para o start screen
				game_over()
		is_restarting = false

func game_over():
	# Ir para a tela de Game Over
	is_restarting = false
	get_tree().change_scene_to_file("res://Scene/gameOver.tscn")

func restore_players():
	# Restaurar ambos os jogadores (usado ao completar fase)
	player1_alive = true
	player2_alive = true
