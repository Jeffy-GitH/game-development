extends Control

@onready var novo_jogo_button = $VBoxContainer/NovoJogoButton
@onready var controles_button = $VBoxContainer/ControlesButton
@onready var sair_button = $VBoxContainer/SairButton
@onready var controles_panel = $ControlesPanel
@onready var voltar_button = $ControlesPanel/VBoxContainer/VoltarButton

func _ready():
	# Conectar os botões aos seus métodos
	novo_jogo_button.pressed.connect(_on_novo_jogo_pressed)
	controles_button.pressed.connect(_on_controles_pressed)
	sair_button.pressed.connect(_on_sair_pressed)
	voltar_button.pressed.connect(_on_voltar_pressed)
	
	# Esconder o painel de controles inicialmente
	controles_panel.visible = false

func _on_novo_jogo_pressed():
	# Resetar estados dos players
	Global.player1_alive = true
	Global.player2_alive = true
	Global.score = 0
	Global.lives = 3
	# Iniciar o level_1
	get_tree().change_scene_to_file("res://Scene/level_1.tscn")

func _on_controles_pressed():
	# Mostrar o painel de controles
	controles_panel.visible = true

func _on_voltar_pressed():
	# Esconder o painel de controles
	controles_panel.visible = false

func _on_sair_pressed():
	# Fechar o jogo
	get_tree().quit()

