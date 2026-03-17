extends CanvasLayer

signal start_game
signal show_leaderboard

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func _on_new_game_pressed() -> void:
	start_game.emit()

func _on_leaderboard_pressed() -> void:
	show_leaderboard.emit()

func _on_quit_pressed() -> void:
	get_tree().quit()
