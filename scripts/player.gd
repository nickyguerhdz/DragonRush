extends CharacterBody2D

# --- VARIABLES DEL JUEGO ---
# Velocidad a la que corre hacia adelante (nunca se detiene)
const SPEED = 400.0 
# Fuerza del salto (es negativa porque en Godot hacia arriba es negativo)
const JUMP_VELOCITY = -600.0

# Obtenemos la gravedad de Godot y la multiplicamos por 2.5 
# para que el salto se sienta rápido y pesado, como en Geometry Dash
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2.5

# --- CICLO PRINCIPAL ---
# Esta función se ejecuta todo el tiempo, 60 veces por segundo
func _physics_process(delta):
	
	# 1. APLICAR GRAVEDAD (Si no está pisando el suelo, cae)
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. SALTAR (Si presionamos el botón "jump" que configuramos antes Y está en el suelo)
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. CORRER AUTOMÁTICAMENTE (El jugador no controla ir a la derecha, el juego lo hace)
	velocity.x = SPEED

	# 4. MOVER AL PERSONAJE (Godot hace las matemáticas de las físicas aquí)
	move_and_slide()
