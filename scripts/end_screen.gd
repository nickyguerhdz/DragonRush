extends CanvasLayer

@onready var click_sound = get_node_or_null("ClickSound")
@export_file("*.tscn") var next_scene_path: String

func _ready():
	var todos_los_botones = get_tree().get_nodes_in_group("botones_sonoros")
	
	for boton in todos_los_botones:
		if boton is BaseButton and is_ancestor_of(boton):
			boton.pressed.connect(_on_any_button_pressed)
			boton.mouse_entered.connect(func(): boton.self_modulate = Color(1.2, 1.2, 1.2))
			boton.mouse_exited.connect(func(): boton.self_modulate = Color(1, 1, 1))
			boton.button_down.connect(func(): boton.self_modulate = Color(0.7, 0.7, 0.7))
			boton.button_up.connect(func(): boton.self_modulate = Color(1.2, 1.2, 1.2))
	
	var btn = get_node_or_null("Buttons/NextLevelButton")
	if btn:
		if not btn.pressed.is_connected(_on_next_level_pressed):
			btn.pressed.connect(_on_next_level_pressed)
	else:
		print("ERROR: No se encontró NextLevelButton en EndScreen. Revisa la jerarquía.")

func _on_any_button_pressed():
	if click_sound:
		click_sound.play()
		print("¡Sonido de click activado!")
		await get_tree().create_timer(0.15).timeout
	else:
		print("ERROR: No se encontró el nodo ClickSound")

func _on_continue_button_pressed():
	self.hide()
	var wisdom = get_parent().get_node("WisdomScreen")
	if wisdom:
		wisdom.aparecer_con_animacion()
	else:
		print("ERROR: No se encontró el nodo WisdomScreen")

func _on_next_level_pressed():
	if click_sound: 
		click_sound.play()
	
	await get_tree().create_timer(0.2).timeout
	if next_scene_path != "":
		get_tree().change_scene_to_file(next_scene_path)
	else:
		print("¡Felicidades! No hay más niveles configurados.")
