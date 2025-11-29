extends StaticBody2D

var life = 3

func _on_area_2d_area_entered(area: Area2D) -> void:
	
	if area.is_in_group("Player"):
		$AnimatedSprite2D.play("Hit")
		life -= 1
		if life <= 0:
			area.get_parent().velocity.y = -450
			$CPUParticles2D.restart()
			$CollisionShape2D.queue_free()
			$AnimatedSprite2D.queue_free()
			$Area2D.queue_free()
			
			await get_tree().create_timer(1).timeout
			
			queue_free()
	
	pass 
