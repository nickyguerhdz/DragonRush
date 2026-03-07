extends Area2D

# Esta línea busca el CanvasLayer (la interfaz) que acabamos de crear y lo guarda en una variable
@onready var pantalla_victoria = $CanvasLayer

func _on_body_entered(body):
	if body.name == "Player2":
		
		# 1. Le decimos al "cerebro" del jugador que deje de calcular físicas (se congela)
		body.set_physics_process(false)
		
		# 2. Hacemos que aparezca nuestro texto gigante en pantalla
		pantalla_victoria.show()	
