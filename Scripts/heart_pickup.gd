extends Area2D


func _on_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("Player"):
		
		# Adicionar 1 vida (com limite máximo, se necessário)
		if Global.lives < 99:  # Limite máximo de vidas
			Global.lives += 1
		
		$AnimatedSprite2D.play("Collected")
		
		$CollisionShape2D.queue_free()
		
		await get_tree().create_timer(1).timeout
		
		queue_free()
	
	pass # Replace with function body.

