extends Area2D

func _on_body_entered(body):
	if body.name == "Player2":
		# Le pedimos a Godot que espere a terminar las físicas para reiniciar
		get_tree().call_deferred("reload_current_scene")
