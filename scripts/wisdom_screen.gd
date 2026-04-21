extends CanvasLayer

@onready var click_sound = $ClickSound
@onready var audio_player = $PronunciationPlayer

@export_file("*.tscn") var next_level_path: String
@export var es_ultimo_nivel: bool = false

func _ready():
	actualizar_pergaminos()
	conectar_clics_en_lista($OptionalScrolls)
	conectar_clics_en_lista($RequiredScrolls)
	
	# Cambiamos la lógica para que busque el nodo por su nombre original siempre
	var btn = get_node_or_null("Buttons/NextLevelButton")
	if btn:
		# Solo cambiamos el texto visual, NO el nombre del nodo
		if es_ultimo_nivel:
			var label = btn.get_node_or_null("Label")
			if label: label.text = "RESTART JOURNEY"
		
		# Conectamos la señal una sola vez de forma segura
		if not btn.pressed.is_connected(_on_next_level_pressed):
			btn.pressed.connect(_on_next_level_pressed)
	else:
		print("ERROR: No se encontró Buttons/NextLevelButton")
	
	if not audio_player.finished.is_connected(_on_pronunciation_finished):
		audio_player.finished.connect(_on_pronunciation_finished)

	var todos_los_botones = get_tree().get_nodes_in_group("botones_sonoros")
	for boton in todos_los_botones:
		if boton is BaseButton and is_ancestor_of(boton):
			if not boton.pressed.is_connected(_on_any_button_pressed):
				boton.pressed.connect(_on_any_button_pressed)
				
			boton.mouse_entered.connect(func(): boton.self_modulate = Color(1.2, 1.2, 1.2))
			boton.mouse_exited.connect(func(): boton.self_modulate = Color(1, 1, 1))
			boton.button_down.connect(func(): boton.self_modulate = Color(0.7, 0.7, 0.7))
			boton.button_up.connect(func(): boton.self_modulate = Color(1.2, 1.2, 1.2))

func _on_any_button_pressed():
	if click_sound: click_sound.play()

func _on_next_level_pressed():
	var sound = get_node_or_null("ClickSound")
	if not sound: sound = get_node_or_null("../EndScreen/ClickSound")
	if sound: sound.play()
	
	await get_tree().create_timer(0.2).timeout
	
	GameManager.murio_recientemente = false 
	GameManager.ya_visto_inicio = false
	
	if es_ultimo_nivel:
		GameManager.reset_puntos()
	
	if next_level_path != "":
		get_tree().change_scene_to_file(next_level_path)
	else:
		print("ERROR: No pusiste la ruta del Nivel 1 en el Inspector del Nivel 3")


func actualizar_pergaminos():
	var req_container = $RequiredScrolls
	for i in range(GameManager.required_collected.size()):
		var nombre_nodo = "Scroll" + str(i + 1)
		if req_container.has_node(nombre_nodo):
			var scroll_node = req_container.get_node(nombre_nodo)
			aplicar_estado(scroll_node, GameManager.required_collected[i])
	
	var opt_container = $OptionalScrolls
	for i in range(GameManager.optional_collected.size()):
		var nombre_nodo = "Scroll" + str(i + 1)
		if opt_container.has_node(nombre_nodo):
			var scroll_node = opt_container.get_node(nombre_nodo)
			aplicar_estado(scroll_node, GameManager.optional_collected[i])

func aplicar_estado(nodo, recolectado):
	if recolectado:
		nodo.set_meta("final_color", Color(1, 1, 1, 1))
		nodo.get_node("Caracter").show()
		nodo.get_node("Romanization").show()
		nodo.get_node("Translation").show()
	else:
		nodo.set_meta("final_color", Color(0.2, 0.2, 0.2, 0.7))
		nodo.get_node("Caracter").hide()
		nodo.get_node("Romanization").hide()
		nodo.get_node("Translation").hide()

func aparecer_con_animacion():
	actualizar_pergaminos()
	self.show()
	
	var todos = $RequiredScrolls.get_children() + $OptionalScrolls.get_children()
	
	for nodo in todos:
		if not nodo.has_meta("pos_original"):
			nodo.set_meta("pos_original", nodo.position)
			
		var pos_real = nodo.get_meta("pos_original")
		var destino_color = nodo.get_meta("final_color")
		
		nodo.position.y = pos_real.y - 50
		nodo.modulate.a = 0
		
		var tween = create_tween().set_parallel(true)
		tween.tween_property(nodo, "position", pos_real, 0.4).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		tween.tween_property(nodo, "modulate", destino_color, 0.4)
		
		await get_tree().create_timer(0.08).timeout

func conectar_clics_en_lista(contenedor):
	for scroll in contenedor.get_children():
		if not scroll.gui_input.is_connected(_on_scroll_gui_input):
			scroll.gui_input.connect(_on_scroll_gui_input.bind(scroll))
		scroll.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND

func _on_scroll_gui_input(event, nodo_scroll):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		buscar_y_reproducir(nodo_scroll)

func buscar_y_reproducir(nodo):
	var label_traduccion = nodo.get_node("Translation")
	if label_traduccion and label_traduccion.visible:
		var nombre_archivo = label_traduccion.text.to_lower().strip_edges()
		var ruta = "res://assets/pronunciation/" + nombre_archivo + ".mp3"
		
		var sonido = load(ruta)
		
		if sonido:
			var bgm = get_tree().current_scene.get_node_or_null("BGM")
			if bgm: bgm.volume_db = -15.0
			audio_player.stream = sonido
			audio_player.play()
		else:
				print("No se pudo cargar el audio: ", ruta)

func _on_pronunciation_finished():
	var bgm = get_tree().current_scene.get_node_or_null("BGM")
	if bgm: bgm.volume_db = -10.0
