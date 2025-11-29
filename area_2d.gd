extends Area2D

@export var level = "Digite"


func _on_area_entered(area: Area2D) -> void:
	# Verificar se a área pertence a um jogador (verificando o parent)
	var parent = area.get_parent()
	if parent and (parent.is_in_group("players") or parent.is_in_group("player") or parent.is_in_group("player2")):
		# Restaurar ambos os jogadores ao completar a fase
		Global.restore_players()
		
		# Verificar se estamos no level_09 - se sim, ir para game over
		var current_scene = get_tree().current_scene
		if current_scene:
			var scene_name = current_scene.scene_file_path.get_file()
			if scene_name == "level_09.tscn":
				get_tree().call_deferred("change_scene_to_file", "res://Scene/gameOver.tscn")
				return
		
		# Usar call_deferred para evitar remover CollisionObject durante callback de física
		get_tree().call_deferred("change_scene_to_file", level)
	
	pass 
