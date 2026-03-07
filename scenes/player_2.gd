extends CharacterBody2D

const SPEED = 650.0 
const JUMP_VELOCITY = -1000.0
var direccion_gravedad = 1 # 1 abajo, -1 arriba

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2.7

func _physics_process(delta):
	# Aplicamos gravedad multiplicada por la dirección
	velocity.y += gravity * delta * direccion_gravedad

	# Salto dinámico (detecta si el suelo es arriba o abajo)
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() and direccion_gravedad == 1:
			velocity.y = JUMP_VELOCITY
		elif is_on_ceiling() and direccion_gravedad == -1:
			velocity.y = -JUMP_VELOCITY

	velocity.x = SPEED
	move_and_slide()

func cambiar_gravedad(nueva_dir):
	direccion_gravedad = nueva_dir
	$Sprite2D.flip_v = (nueva_dir == -1) # Se voltea si es -1 (arriba)
	
	# Empujón para que despegue del techo/suelo inmediatamente
	velocity.y = 500.0 * direccion_gravedad
