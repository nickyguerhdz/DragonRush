extends Node

var ya_visto_inicio = false
var murio_recientemente = false
var puntos_por_scroll = 300
var puntos_nivel_completo = 500
var scrolls_required = 0
var scrolls_optional = 0
var best_score = 0

var required_collected = [false, false, false, false, false] # 5 scrolls
var optional_collected = [false, false, false, false]       # 4 scrolls

func _ready():
	cargar_best_score()

func guardar_best_score(nuevo_score):
	if nuevo_score > best_score:
		best_score = nuevo_score
		var file = FileAccess.open("user://savegame.data", FileAccess.WRITE)
		file.store_var(best_score)
		file.close()

func cargar_best_score():
	if FileAccess.file_exists("user://savegame.data"):
		var file = FileAccess.open("user://savegame.data", FileAccess.READ)
		best_score = file.get_var()
		file.close()

func reset_puntos():
	required_collected = [false, false, false, false, false]
	optional_collected = [false, false, false, false]

func recolectar_required(index):
	if index < required_collected.size():
		required_collected[index] = true

func recolectar_optional(index):
	if index < optional_collected.size():
		optional_collected[index] = true

func get_total_required():
	return required_collected.count(true)

func get_total_optional():
	return optional_collected.count(true)

func obtener_total():
	var req = get_total_required()
	var opt = get_total_optional()
	var total_scrolls = req + opt
	
	var puntaje_final = (total_scrolls * puntos_por_scroll) + puntos_nivel_completo
	return puntaje_final

func borrar_best_score():
	var path = "user://savegame.data"
	if FileAccess.file_exists(path):
		DirAccess.remove_absolute(path)
		best_score = 0
		print("Puntaje máximo eliminado con éxito.")
	else:
		print("No hay ningún puntaje guardado para borrar.")
	
	
