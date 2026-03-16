extends CharacterBody2D

const SPEED = 650.0 
const JUMP_VELOCITY = -1000.0

var direccion_gravedad = 1
var game_started = false
var start_jump = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2.7

func _physics_process(delta):

	if !game_started:
		return

	velocity.y += gravity * delta * direccion_gravedad

	# salto normal
	if Input.is_action_just_pressed("jump"):
		if is_on_floor() and direccion_gravedad == 1:
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.play("jumping")

		elif is_on_ceiling() and direccion_gravedad == -1:
			velocity.y = -JUMP_VELOCITY
			$AnimatedSprite2D.play("jumping")

	# termina salto inicial
	if start_jump and is_on_floor():
		start_jump = false
		$AnimatedSprite2D.play("running")

	if !start_jump:
		velocity.x = SPEED

	move_and_slide()

func start_game():
	game_started = true
	start_jump = true
	velocity.y = JUMP_VELOCITY
	$AnimatedSprite2D.play("jumping")

func cambiar_gravedad(nueva_dir):
	direccion_gravedad = nueva_dir
	$AnimatedSprite2D.flip_v = (nueva_dir == -1) # Se voltea si es -1 (arriba)
	velocity.y = 500.0 * direccion_gravedad
