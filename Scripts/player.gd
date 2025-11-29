extends CharacterBody2D

var speed = 160
var jump_velocity = -600
var dir
var gravidade = 800
var jumps = 5
var is_alive = true

func _ready() -> void:
	add_to_group("player")
	add_to_group("players")

func _physics_process(delta: float) -> void:
	move(delta)
	animations()
	fall()

func move(delta):
	dir = Input.get_axis("left", "Right")
	if dir:
		velocity.x = dir * speed
	else:
		velocity.x = 0
	if Input.is_action_just_pressed("jump") and jumps > 0:
		velocity.y = jump_velocity
		if jumps > 0:
			jumps -= 1
	if not is_on_floor():
		velocity.y += gravidade * delta
	if is_on_floor():
		jumps = 1
	velocity.y += gravidade * delta
	move_and_slide()

func animations():
	if not is_on_floor():
		# Se estiver no ar, mostrar animação de jump
		if $AnimatedSprite2D.animation != "jump":
			$AnimatedSprite2D.play("jump")
	elif velocity.x != 0:
		# Se estiver no chão e se movendo, mostrar run
		$AnimatedSprite2D.play("run")
	else:
		# Se estiver no chão e parado, mostrar idle
		$AnimatedSprite2D.play("idle")
	
	if dir > 0:
		$AnimatedSprite2D.flip_h = false
	elif dir < 0:
		$AnimatedSprite2D.flip_h = true

func die():
	if not is_alive:
		return
	is_alive = false
	$AnimatedSprite2D.play("Hit")
	remove_from_group("players")
	$CollisionShape2D.queue_free()
	$Area2D.queue_free()
	velocity.y = jump_velocity
	#restart(0.0)
	Global.player1_alive = false
	queue_free()

func restart(_time: float):
	await get_tree().create_timer(0.4).timeout
	get_tree().reload_current_scene()

func fall():
	if global_position.y >= 202 and is_alive:
		die()

func take_damage(_amount: int):
	if not is_alive:
		return
	die()
