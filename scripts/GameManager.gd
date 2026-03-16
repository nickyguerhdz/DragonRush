extends Node

var ya_visto_inicio = false
var scrolls_required = 0  # Contador para los obligatorios
var scrolls_optional = 0  # Contador para los extras
var puntos_por_scroll = 300
var puntos_nivel_completo = 500

# Función para resetear puntos al morir o iniciar nivel
func reset_puntos():
	scrolls_required = 0
	scrolls_optional = 0

func sumar_required():
	scrolls_required += 1

func sumar_optional():
	scrolls_optional += 1

func obtener_total():
	return ((scrolls_required + scrolls_optional) * puntos_por_scroll) + puntos_nivel_completo
