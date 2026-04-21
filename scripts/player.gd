extends CharacterBody2D

const SPEED = 650.0 
const JUMP_VELOCITY = -1000.0

@onready var camera = $Camera2D
@onready var shake_timer = $Camera2D/ShakeTimer
var shake_intensity = 0.0
var es_sombra = false

var direccion_gravedad = 1
var game_started = false
var start_jump = false
var iman_activo = false

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2.7

func _ready():
	$AnimatedSprite2D.play("idle")
	if shake_timer:
		shake_timer.one_shot = true

func _physics_process(delta):
	if game_started and !shake_timer.is_stopped():
		camera.offset = Vector2(
			randf_range(-1, 1) * shake_intensity,
			randf_range(-1, 1) * shake_intensity
		)
	else:
		camera.offset = Vector2.ZERO

	if !game_started:
		if $AnimatedSprite2D.animation != "idle":
			$AnimatedSprite2D.play("idle")
		return

	velocity.y += gravity * delta * direccion_gravedad

	if Input.is_action_just_pressed("jump"):
		if (is_on_floor() or abs(velocity.y) < 50) and direccion_gravedad == 1:
			velocity.y = JUMP_VELOCITY
			$AnimatedSprite2D.play("jumping")

		elif is_on_ceiling() and direccion_gravedad == -1:
			velocity.y = -JUMP_VELOCITY
			$AnimatedSprite2D.play("jumping")

	if start_jump and is_on_floor():
		start_jump = false
		$AnimatedSprite2D.play("running")

	if !start_jump:
		velocity.x = SPEED
	
	if not is_on_floor():
		velocity.x = move_toward(velocity.x, SPEED, 10.0) # Mantie

	move_and_slide()

func _process(_delta):
	if es_sombra:
		crear_fantasma()

func crear_fantasma():
	var fantasma = Sprite2D.new()
	fantasma.texture = $AnimatedSprite2D.sprite_frames.get_frame_texture($AnimatedSprite2D.animation, $AnimatedSprite2D.frame)
	fantasma.global_position = global_position
	fantasma.modulate = Color(0.6, 0.3, 0.9, 0.4)
	get_tree().current_scene.add_child(fantasma)
	
	var t = create_tween()
	t.tween_property(fantasma, "modulate:a", 0, 0.4)
	t.finished.connect(fantasma.queue_free)

func aplicar_golpe(tiempo, intensidad):
	shake_intensity = intensidad
	shake_timer.wait_time = tiempo
	shake_timer.start()

func start_game():
	game_started = true
	start_jump = true
	velocity.y = JUMP_VELOCITY
	$AnimatedSprite2D.play("jumping")

func cambiar_gravedad(nueva_dir):
	direccion_gravedad = nueva_dir
	$AnimatedSprite2D.flip_v = (nueva_dir == -1) # Se voltea si es -1 (arriba)
	velocity.y = 500.0 * direccion_gravedad

func activar_iman(duracion):
	iman_activo = true
	await get_tree().create_timer(duracion).timeout
	iman_activo = false

func activar_paso_sombra(duracion):
	es_sombra = true
	
	set_collision_mask_value(1, true) 
	
	modulate = Color(0.5, 0.2, 0.8, 0.5)
	
	await get_tree().create_timer(duracion).timeout
	
	set_collision_mask_value(2, true)
	modulate = Color(1, 1, 1, 1)
	es_sombra = false
