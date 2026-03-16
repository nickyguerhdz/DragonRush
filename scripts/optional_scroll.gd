extends Area2D

func _on_body_entered(body):
	if body.name == "Player":
		GameManager.sumar_optional()
		queue_free()
