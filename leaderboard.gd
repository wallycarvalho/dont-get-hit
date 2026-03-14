extends CanvasLayer
signal menu_pressed

const leaderboard_save_file = "user://leaderboard.save"

var has_loaded_comp_list:bool = false

var player_name:
	get = get_player_name
var score:
	set = set_score
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$ScrollContainer/GridContainer/NameHeader/PanelContainer/Label.text = "Name"
	$ScrollContainer/GridContainer/ScoreHeader/PanelContainer/Label.text = "Score"
	$ScrollContainer/GridContainer/RankHeader/PanelContainer/Label.text = "Rank"
	get_tree().call_group("CompList", "hide")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func get_player_name() -> String:
	var player_name = $PlayerEdit.text
	return player_name

func set_score(value) -> void:
	score = value
	
func sort_by_score(a, b) -> bool:
	if int(a[1]) > int(b[1]):
		return true
	
	return false
	
	
func get_competitors() -> Array:
	if not FileAccess.file_exists(leaderboard_save_file):
		print("file not found")
		# do something later
		return []
	
	var competitors = FileAccess.open(leaderboard_save_file, FileAccess.READ)
	var final_list = []
	while competitors.get_position() < competitors.get_length():
		var line = competitors.get_line()
		
		var json = JSON.new()
		
		var parsed_line = json.parse(line)
		if not parsed_line == OK:
			# an error happened
			continue
			
		var node_data = json.data
		final_list.append([
			node_data['player_name'],
			node_data['score']
			])

	final_list.sort_custom(sort_by_score)
	return final_list
	
func load_competitors_data_and_grid() -> void:
	if has_loaded_comp_list:
		return
		
	var list_of_competitors = get_competitors()	
	
	for i in range(list_of_competitors.size()):
		var label_for_name = preload("res://interface/list_label.tscn").instantiate()
		var label_for_score = preload("res://interface/list_label.tscn").instantiate()
		var label_for_rank = preload("res://interface/list_label.tscn").instantiate()
		var grid_container = $ScrollContainer/GridContainer
		var curr = list_of_competitors[i]
		grid_container.add_child(label_for_rank)
		grid_container.add_child(label_for_name)
		grid_container.add_child(label_for_score)
		
		label_for_rank.set_item_label(str(i + 1))
		label_for_name.set_item_label(curr[0])
		label_for_score.set_item_label(curr[1])
		
	# if we loaded the children successfully, toggle state variable so we don't redo the work
	if $ScrollContainer/GridContainer.get_children().size() > 0:
		has_loaded_comp_list = true
		
	
func _on_save_pressed() -> void:
	var save_file = FileAccess.open(leaderboard_save_file, FileAccess.READ_WRITE)
	var player_leaderboard_info = { 'player_name': player_name, 'score': str(score) }
	
	save_file.seek_end()
	save_file.store_line(JSON.stringify(player_leaderboard_info))	
	save_file.close()
	
	$SaveButton.hide()
	$PlayerEdit.hide()
	get_tree().call_group("CompList", "show")
	load_competitors_data_and_grid()
		
func show_save_group() -> void:
	get_tree().call_group("save_group", "show")
	get_tree().call_group("CompList", "hide")
	
func show_comp_list() -> void:
	get_tree().call_group("save_group", "hide")
	get_tree().call_group("CompList", "show")
	load_competitors_data_and_grid()
	
func _on_back_button_pressed() -> void:
	menu_pressed.emit()
