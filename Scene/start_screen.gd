extends Control


func _on_new_game_pressed() -> void:
	# Resetar estados dos players e vidas
	Global.player1_alive = true
	Global.player2_alive = true
	Global.score = 0
	Global.lives = 3
	get_tree().change_scene_to_file("res://Scene/level_01.tscn")
	pass # Replace with function body.


func _on_scores_pressed() -> void:
	Global.scores_previous_scene = "startScreen.tscn"
	get_tree().change_scene_to_file("res://Scene/scores.tscn")
	pass # Replace with function body.

func _on_credits_pressed() -> void:
	pass # Replace with function body.


func _on_exit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
