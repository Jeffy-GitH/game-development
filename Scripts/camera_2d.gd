extends Camera2D

var player
var player2
var min_zoom = 0.5
var max_zoom = 0.5
var zoom_margin = 80 # Margem ao redor dos players
var players_initialized = false

func _ready():
	# Resetar os estados dos players ao iniciar uma nova fase
	Global.player1_alive = true
	Global.player2_alive = true
	
	# Resetar as referências dos players
	player = null
	player2 = null
	
	# Resetar o zoom para o valor padrão ao iniciar uma nova fase
	zoom = Vector2(max_zoom, max_zoom)
	players_initialized = false
	
	# Encontra os players automaticamente
	find_players()
	
	# Remove as câmeras dos players
	remove_player_cameras()

func _process(delta):
	
	camera_2p(delta)
	camera_1p(delta)
	pass
	

func find_players():
	if not player:
		player = get_tree().get_first_node_in_group("player")
	if not player2:
		player2 = get_tree().get_first_node_in_group("player2")

func remove_player_cameras():
	# Remove as câmeras dos players individuais
	var players = get_tree().get_nodes_in_group("players")
	for player_node in players:
		var camera = player_node.get_node_or_null("Camera2D")
		if camera:
			camera.enabled = false
			camera.queue_free()

func camera_2p(delta):
	
	if not Global.player1_alive or not Global.player2_alive:
		return
	if player and player2 and is_instance_valid(player) and is_instance_valid(player2):
		# Calcula a posição média entre os dois players
		var center_position = (player.global_position + player2.global_position) / 2
		global_position = center_position
		
		# Calcula o zoom baseado na distância entre os players
		var distance = player.global_position.distance_to(player2.global_position)
		var target_zoom = clamp(distance / zoom_margin, min_zoom, max_zoom)
		
		# Se é a primeira vez que os players são encontrados, inicializa o zoom imediatamente
		if not players_initialized:
			zoom = Vector2(target_zoom, target_zoom)
			players_initialized = true
		else:
			# Suaviza o zoom
			zoom = lerp(zoom, Vector2(target_zoom, target_zoom), 2 * delta)
	else:
		# Se um player morrer, tenta encontrar os players novamente
		find_players()
		# Se os players foram encontrados, inicializa o zoom corretamente
		if player and player2 and is_instance_valid(player) and is_instance_valid(player2):
			var distance = player.global_position.distance_to(player2.global_position)
			var target_zoom = clamp(distance / zoom_margin, min_zoom, max_zoom)
			zoom = Vector2(target_zoom, target_zoom)
			players_initialized = true


func camera_1p(_delta):
	
	if Global.player1_alive and not Global.player2_alive:
		if player and is_instance_valid(player):
			global_position = player.global_position
		else:
			find_players()
	elif Global.player2_alive and not Global.player1_alive:
		if player2 and is_instance_valid(player2):
			global_position = player2.global_position
		else:
			find_players()
