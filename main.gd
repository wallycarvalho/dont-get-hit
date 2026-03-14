extends Node

@export var mob_scene: PackedScene
var score
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Leaderboard.hide()	

	$Background.volume_db = -25
	$Background.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("stop_game"):
		get_tree().quit()

func new_game() -> void:
	score = 0
	$Player.start($StartPosition.position)
	$StartTimer.start()
	
	# HUD portion
	$HUD.update_score(score)
	$HUD.show_message("Starting game")
	# hide leaderboard button
	$HUD/LeaderboardButton.hide()
	
	# Music
	$Background.volume_db = 0


func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	
	# call reference to HUD
	$HUD.show_game_over()
	
	# Remove all mobs
	get_tree().call_group("mobs", "queue_free")
	
	$Background.stop()
	$DeathSound.play()
	
	await get_tree().create_timer(2.4).timeout
	$Background.play()
	$Background.volume_db = -25
	
	# leaderboard logic
	"""
	1. save the score
	2. hide score, message, and button
	3. show leaderboard
	4. allow user to save leaderboard
	5. introduce button to show leaderboard from main scene
	"""
	
	print("my current score is " + str(score))
	$Leaderboard.score = score
	$HUD.hide()
	$Leaderboard.show()
	$Leaderboard.show_save_group()
	
	
func save_game():
	var save_file = FileAccess.open("user://leaderboard.save", FileAccess.WRITE)
	save_file.store_line(score)


func show_leaderboard() -> void:
	"""
	This can be improved by handling the variables better so we call only one variable instead of showing
	ledaerboard + the associated group
	"""
	$HUD.hide()
	$Leaderboard.show()
	$Leaderboard.show_comp_list()
	
func show_main_screen() -> void:
	$HUD.show()
	$HUD/LeaderboardButton.show()
	$Leaderboard.hide()

func _on_mob_timer_timeout() -> void:
	# first instantiate the mob
	var mob = mob_scene.instantiate()
	
	# choose a random location
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	
	# set the mob location
	mob.position = mob_spawn_location.position
	
	# direction time
	var dir = mob_spawn_location.rotation * PI / 2
		
	# add randomess
	dir += randf_range(-PI / 4, PI / 4)
	mob.rotation = dir
	
	var velocity = Vector2(randf_range(150.0, 240.0), 0.0)
	mob.linear_velocity = velocity.rotated(dir)
	
	# spawn 
	add_child(mob)

func _on_score_timer_timeout() -> void:
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout() -> void:
	$MobTimer.start()
	$ScoreTimer.start()
