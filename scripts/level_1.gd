extends Node2D

@onready var player = $Player
@onready var start_ui = $StartScreen
@onready var try_again_screen = $TryAgainScreen
@onready var wisdom_screen = $WisdomScreen
@onready var end_screen = $EndScreen

func _ready():
	start_ui.hide()
	try_again_screen.hide()
	end_screen.hide()
	wisdom_screen.hide()
	GameManager.reset_puntos()
	
	if GameManager.ya_visto_inicio == false:
		start_ui.show()
		player.game_started = false
	else:
		try_again_screen.show()
		var death_audio = try_again_screen.get_node("DeathSound")
		
		if death_audio:
			death_audio.play()
		player.game_started = false 

func start_game():
	player.start_game()
	start_ui.hide()
	try_again_screen.hide()
	GameManager.ya_visto_inicio = true 

func _input(event):
	if !player.game_started and event.is_action_pressed("ui_accept"):
		start_game()
		
	if event.is_action_pressed("borrar_record"):
		GameManager.borrar_best_score()
		if has_node("StartScreen/LabelBestScore"):
			$StartScreen/BestScore.hide()
		print("Récord reseteado")

func _on_killzone_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		if end_screen.visible:
			return
		get_tree().call_deferred("reload_current_scene")
