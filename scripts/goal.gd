extends Area2D

@onready var end_screen = get_node("/root/Level1/EndScreen")

func _on_body_entered(body):
	if body.name == "Player":
		
		if end_screen == null:
			print("ERROR: No se encontró EndScreen en la ruta especificada")
			return
		
		body.set_physics_process(false)
		
		var pts_req = GameManager.scrolls_required * GameManager.puntos_por_scroll
		var pts_opt = GameManager.scrolls_optional * GameManager.puntos_por_scroll
		
		var stars_container = end_screen.get_node("Stars")
		
		for star in stars_container.get_children():
			star.modulate.a = 0.3
		
		if GameManager.scrolls_required >= 1:
			stars_container.get_node("Star1").modulate.a = 1.0
		if GameManager.scrolls_required >= 3:
			stars_container.get_node("Star2").modulate.a = 1.0
		if GameManager.scrolls_required == 5:
			stars_container.get_node("Star3").modulate.a = 1.0
		
		end_screen.get_node("Labels/ScrollsCollected").text = "+" + str(pts_req)
		end_screen.get_node("Labels/OptionalsScrolls").text = "+" + str(pts_opt)
		end_screen.get_node("Labels/LevelCompletedPoints").text = "+" + str(GameManager.puntos_nivel_completo)
		end_screen.get_node("Labels/TotalScore").text = str(GameManager.obtener_total())
		
		#print("¡El ninja llegó al templo!")
		end_screen.show()
