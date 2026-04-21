extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		if body.has_method("activar_paso_sombra") and body.es_sombra:
			print("¡Atravesando obstáculos!")
			return
		else:
			body.aplicar_golpe(3, 25.0)		
			
			GameManager.murio_recientemente = true
			
			await get_tree().create_timer(0.8).timeout
			get_tree().call_deferred("reload_current_scene")
