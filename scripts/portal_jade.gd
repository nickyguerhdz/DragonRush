extends Node2D

@export var launch_force = 1200.0 
@export var launch_direction = Vector2(1, -0.5).normalized()

func _ready():
	$DetectionArea.body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Player":
		lanzar_ninja(body)

func lanzar_ninja(player):
	player.set_physics_process(false)
	
	var tween = create_tween()
	tween.tween_property(player, "global_position", global_position, 0.1)
	
	await tween.finished
	
	player.activar_iman(2.5)
	player.set_physics_process(true)
	player.velocity = launch_direction * launch_force
	
	$GPUParticles2D.emitting = true
	if has_node("LaunchSound"):
		$LaunchSound.play()
	
	player.rotation_degrees = 0
	var tween_rot = create_tween()
	tween_rot.tween_property(player, "rotation_degrees", 360, 0.6).set_trans(Tween.TRANS_QUART).set_ease(Tween.EASE_OUT)
