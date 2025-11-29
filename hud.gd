extends CanvasLayer

var life_sprites = []
var heart_texture = preload("res://Sprites/Kings and Pigs/Sprites/12-Live and Coins/Big Heart Idle (18x14).png")
var last_lives_count = -1

func _ready():
	update_lives_display()
	last_lives_count = Global.lives

func create_heart_sprite_frames() -> SpriteFrames:
	var sprite_frames = SpriteFrames.new()
	
	# Verificar se a animação já existe antes de adicionar
	if not sprite_frames.has_animation("default"):
		sprite_frames.add_animation("default")
	
	# Limpar frames existentes se houver
	if sprite_frames.get_frame_count("default") > 0:
		sprite_frames.clear("default")
	
	# Adicionar os 8 frames do coração
	for i in range(8):
		var atlas_texture = AtlasTexture.new()
		atlas_texture.atlas = heart_texture
		atlas_texture.region = Rect2(i * 18, 0, 18, 14)
		sprite_frames.add_frame("default", atlas_texture, 1.0)
	
	sprite_frames.set_animation_loop("default", true)
	sprite_frames.set_animation_speed("default", 8.0)
	return sprite_frames

func _process(_delta: float) -> void:
	$Sco/Score.text = str(Global.score)
	
	# Atualizar apenas se o número de vidas mudou
	if Global.lives != last_lives_count:
		update_lives_display()
		last_lives_count = Global.lives

func update_lives_display():
	# Limpar sprites antigos
	for sprite in life_sprites:
		if is_instance_valid(sprite):
			sprite.queue_free()
	life_sprites.clear()
	
	# Verificar se o container existe
	if not has_node("Lives"):
		print("ERRO: Container 'Lives' não encontrado!")
		return
	
	var lives_container = $Lives
	
	# Criar os sprites de vida
	for i in range(Global.lives):
		var life_sprite = AnimatedSprite2D.new()
		life_sprite.sprite_frames = create_heart_sprite_frames()
		life_sprite.position = Vector2(i * 25, 0)
		life_sprite.scale = Vector2(0.5, 0.5)
		life_sprite.autoplay = "default"
		lives_container.add_child(life_sprite)
		life_sprite.play("default")
		life_sprites.append(life_sprite)
