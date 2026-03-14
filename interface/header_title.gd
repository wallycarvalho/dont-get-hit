extends Control

@onready var name_label = $Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_label() -> Label:
	return name_label
	
func set_label(value) -> void:
	name_label.text = value
