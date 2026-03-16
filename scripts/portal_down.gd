extends Area2D

func _on_body_entered(body):
	if body.name == "Player2":
		print("¡TOCASTE EL PORTAL AZUL!")
		body.cambiar_gravedad(1)
