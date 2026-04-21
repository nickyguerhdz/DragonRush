extends Area2D

@export var scroll_index: int = 0

func _on_body_entered(body):
	if body.name == "Player":
		GameManager.recolectar_required(scroll_index)
		
		if has_node("PickupSound"):
			$PickupSound.play()
		
		self.visible = false
		set_deferred("monitoring", false)
		
		await $PickupSound.finished
		queue_free()

@onready var player = get_tree().current_scene.find_child("Player", true, false)
var velocidad_atraccion = 800.0

func _process(delta):
	if player and player.iman_activo:
		var distancia = global_position.distance_to(player.global_position)
		
		if distancia < 500: 
			var direccion = (player.global_position - global_position).normalized()
			global_position += direccion * velocidad_atraccion * delta
			velocidad_atraccion += 50
