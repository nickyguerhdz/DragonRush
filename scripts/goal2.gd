extends Area2D

@onready var end_screen = get_node("/root/Level2/EndScreen")

func _on_body_entered(body):
	if body.name == "Player":
		if end_screen == null:
			print("ERROR: No se encontró EndScreen en la ruta especificada")
			return
		
		body.set_physics_process(false)
		
		var stars_container = end_screen.get_node("Stars")
		var star_audio = end_screen.get_node("StarSound") 
		
		for star in stars_container.get_children():
			star.modulate.a = 0.3
		
		var total_req = GameManager.get_total_required()
		var total_opt = GameManager.get_total_optional()
		var final_score = GameManager.obtener_total()
		
		var pts_req = total_req * GameManager.puntos_por_scroll
		var pts_opt = total_opt * GameManager.puntos_por_scroll
		
		end_screen.get_node("Labels/ScrollsCollected").text = "+" + str(pts_req)
		end_screen.get_node("Labels/OptionalsScrolls").text = "+" + str(pts_opt)
		end_screen.get_node("Labels/LevelCompletedPoints").text = "+" + str(GameManager.puntos_nivel_completo)
		
		GameManager.guardar_best_score(final_score)
		
		end_screen.show()
		
		await animar_conteo_puntos(end_screen.get_node("Labels/TotalScore"), final_score)
		
		if total_req >= 1:
			await get_tree().create_timer(0.4).timeout 
			stars_container.get_node("Star1").modulate.a = 1.0
			if star_audio: star_audio.play()
			
		if total_req >= 3:
			await get_tree().create_timer(0.4).timeout
			stars_container.get_node("Star2").modulate.a = 1.0
			if star_audio: star_audio.play()
			
		if total_req == 5:
			await get_tree().create_timer(0.4).timeout
			stars_container.get_node("Star3").modulate.a = 1.0
			if star_audio: star_audio.play()

		print("¡Nivel completado y record guardado!")

func animar_conteo_puntos(label, valor_final):
	var conteo = 0
	var paso = valor_final / 10
	for i in range(11):
		label.text = str(int(conteo))
		conteo += paso
		if conteo > valor_final: conteo = valor_final
		await get_tree().create_timer(0.05).timeout
	label.text = str(valor_final)
