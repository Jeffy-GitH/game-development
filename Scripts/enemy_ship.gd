extends CharacterBody2D

var detection_range = 2000
var shoot_range = 400
var rotation_speed = 2.0

var player
var player2

# Dicionário por nomes de grupo
var player_hits = {"player": 0, "player2": 0}
var max_hits = 3

var can_shoot = true
var shoot_cooldown = 1.5
var bullet_scene = preload("res://Preifats/bullet.tscn")

func _ready():
	add_to_group("enemy_ships")
	find_players()

func _physics_process(_delta):
	# Atualizar referências dos players se necessário
	if not player or (player and not is_instance_valid(player)):
		player = null
		find_players()
	if not player2 or (player2 and not is_instance_valid(player2)):
		player2 = null
		find_players()
	
	# Verificar se pelo menos um player está vivo
	var target = get_closest_player()
	if not target:
		return
	
	#rotate_towards_player(target, delta)
	if (global_position.distance_to(target.global_position) <= shoot_range 
			and can_shoot and is_aiming_at_player(target)):
		shoot_at_player(target)

func find_players():
	if not player:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			player = players[0]
	if not player2:
		var players2 = get_tree().get_nodes_in_group("player2")
		if players2.size() > 0:
			player2 = players2[0]

func get_closest_player():
	var closest_player = null
	var closest_distance = INF
	if player and is_instance_valid(player):
		var distance = global_position.distance_to(player.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_player = player
	if player2 and is_instance_valid(player2):
		var distance = global_position.distance_to(player2.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_player = player2
	return closest_player

func rotate_towards_player(target, delta):
	var direction = (target.global_position - global_position).normalized()
	var target_angle = atan2(direction.y, direction.x)
	rotation = lerp_angle(rotation, target_angle, rotation_speed * delta)

func is_aiming_at_player(target):
	var direction_to_target = (target.global_position - global_position).normalized()
	var current_direction = Vector2(cos(rotation), sin(rotation))
	return direction_to_target.dot(current_direction) > 0.9

func shoot_at_player(target):
	if not can_shoot or not bullet_scene:
		return
	can_shoot = false
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position
	bullet.direction = (target.global_position - global_position).normalized()
	bullet.rotation = atan2(bullet.direction.y, bullet.direction.x)
	bullet.shooter = self  # <--- Importante!
	await get_tree().create_timer(shoot_cooldown).timeout
	can_shoot = true

func register_hit(player_node):
	var group_name = ""
	# Confere qual grupo do player
	if player_node.is_in_group("player"):
		group_name = "player"
	elif player_node.is_in_group("player2"):
		group_name = "player2"
	else:
		return # não controlamos esse player
	player_hits[group_name] += 1
	print("Jogador ", group_name, " atingido! Hits: ", player_hits[group_name])
	if player_hits[group_name] >= max_hits:
		kill_player(player_node)
		player_hits[group_name] = 0  # Zera contador desse player

func kill_player(player_node):
	if player_node and player_node.has_method("die"):
		player_node.die()
		# Limpar a referência do player morto
		if player_node == player:
			player = null
		elif player_node == player2:
			player2 = null
