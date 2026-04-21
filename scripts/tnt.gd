extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		body.aplicar_golpe(3, 25.0)		
		
		await get_tree().create_timer(0.8).timeout
		get_tree().call_deferred("reload_current_scene")
