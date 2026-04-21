extends CanvasLayer

func _ready():
	if GameManager.best_score > 0:
		$BestScore.text = str(GameManager.best_score).pad_zeros(4)
		$BestScore.show()
		$Label.show()
	else:
		$BestScore.hide()
		$Label.hide()
