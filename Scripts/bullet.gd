extends Area2D

var speed = 400
var direction = Vector2.RIGHT
var damage = 1
var max_distance = 500
var distance_traveled = 0
var target_groups = ["player", "player2"]
var shooter = null  # <--- Nave que atirou

func _ready():
	area_entered.connect(_on_area_entered)
	body_entered.connect(_on_body_entered)  # Adicionar detecção de colisão com terreno
	rotation = atan2(direction.y, direction.x)

func _physics_process(delta):
	position += direction * speed * delta
	distance_traveled += speed * delta
	if distance_traveled >= max_distance:
		queue_free()

func _on_area_entered(area):
	var parent = area.get_parent()
	if parent:
		for group in target_groups:
			if parent.is_in_group(group):
				print("Laser acertou: ", parent.name)
				parent.die()
				if shooter and shooter.has_method("register_hit"):
					shooter.register_hit(parent)
					print("Hit registrado na nave inimiga")
				queue_free()
				return

func _on_body_entered(body):
	# Ignorar players e a nave inimiga
	if body.is_in_group("player") or body.is_in_group("player2") or body.is_in_group("enemy_ships"):
		return
	# Quando colide com qualquer corpo físico (terreno, paredes, etc)
	print("Projétil colidiu com: ", body.name)
	queue_free()
